import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'jizdenka.dart';
part 'ceskedrahy.g.dart';

/*
    Copyright (C) 2022 Matyáš Caras

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    */

class CeskeDrahy {
  final Map<String, String> _cookie = {};

  void _parseCookies(List<String> c) {
    for (var full in c) {
      var cookie = full.split(";")[0].split("=");
      if (cookie.length < 2) continue;
      _cookie[cookie[0]] = "${cookie[1]}${(cookie[0] == 'RSID') ? '=' : ''};";
    }
  }

  String _cookieString() {
    var s = "";
    for (var key in _cookie.keys) {
      s += "$key=${_cookie[key]}; ";
    }
    return s;
  }

  Future<void> logIn(String user, String pass) async {
    var r = await http.post(
        Uri.parse("https://www.cd.cz/profil-uzivatele/auth/login"),
        body: {"username": user, "password": pass, "remember": "true"});
    var cookies = r.headers["set-cookie"]!.split(",").toList();
    var je = false;
    for (var element in cookies) {
      if (element.contains("RSID")) {
        je = true;
      }
    }
    if (!je) return Future.error("Neplatné údaje");
    _parseCookies(cookies);
  }

  Future<List<CDJizdenka>> ziskatJizdenky() async {
    if (_cookie.isEmpty) return Future.error("Chybí přihlášení");
    var rft = await http.get(Uri.parse("https://www.cd.cz/eshop/historie"),
        headers: {"Cookie": _cookieString()});
    _parseCookies(rft.headers["set-cookie"]!.split(",").toList());
    var token = RegExp(
            r'(?<=name="__RequestVerificationToken" type="hidden" value=").+?(?=")')
        .firstMatch(rft.body)!
        .group(0)
        .toString();
    var r = await http.post(
        Uri.parse("https://www.cd.cz/eshop/GetUserHistoryData/"),
        headers: {
          "Cookie": _cookieString()
        },
        body: {
          "__RequestVerificationToken": token,
          "model[pageSize]": "10",
          "model[items]": "",
          "model[allItemsCount]": "0",
          "model[buyAgainCartItemID]": "0",
          "model[initPassengers][mapData]": "",
          "model[initPassengers][defaultPassenger]": "",
          "model[initPassengers][avatars]": "",
          "model[isActive]": "false",
          "model[filter][order]": "1",
          "model[filter][ticketStatus]": "0",
          "model[filter][target]": "1",
          "model[filter][cartItemID]": "0",
          "model[filter][enableFilter]": "false",
          "model[filter][showFilter]": "false",
          "model[filter][filterIssueDate]": "",
          "model[filter][filterValidFromDate]": "",
          "model[filter][filterName]": "",
          "model[filter][filterTransactionCode]": "",
          "model[filter][filterCorporateNS]": "",
          "model[filter][corporateNSEnabled]": "false",
          "model[orderTypes][0][name]": "Data+zakoupení",
          "model[orderTypes][0][value]": "0",
          "model[orderTypes][0][shortName]": "",
          "model[orderTypes][1][name]": "Data+a+času+odjezdu",
          "model[orderTypes][1][value]": "1",
          "model[orderTypes][1][shortName]": "",
          "model[pageNumber]": "0",
          "model[initOnly]": "false",
          "model[allEmpty]": "true"
        });
    var data = jsonDecode(r.body);
    var jizdenky = <CDJizdenka>[];
    SharedPreferences p = await SharedPreferences.getInstance();
    var path = p.getString("dlpath")!;
    for (var j in data["items"]) {
      var cd = CDJizdenka.fromJson(j);
      // stáhnout obrázek
      var imgData = await http.get(Uri.parse("https://cd.cz${cd.qrUrl}"),
          headers: {"Cookie": _cookieString()});
      // TODO FIX
      if (imgData.statusCode < 400) {
        var b64Data =
            RegExp(r'src="data:image;base64,(.+?)"').firstMatch(imgData.body);
        if (b64Data != null) {
          print(b64Data.group(1));
          File("$path/${j.id}.png")
              .writeAsBytesSync(base64Decode(b64Data.group(1)!));
        }
      }
      jizdenky.add(cd);
    }
    return jizdenky;
  }
}

@JsonSerializable()
class CDJizdenka implements Jizdenka {
  @override
  @JsonKey(name: "stationTo")
  final String doStanice;

  @override
  final Dopravce dopravce = Dopravce.ceskeDrahy;

  @override
  @JsonKey(name: "name")
  final String jmeno;

  @override
  @JsonKey(name: "validity")
  @_DatumPlatnostiPrevodnik()
  final DateTime platiDo;

  @override
  @JsonKey(name: "validFrom", disallowNullValue: false)
  @_DatumPlatnostiPrevodnik()
  final DateTime platiOd;

  @override
  @JsonKey(name: "trainsThere")
  final List<CDSpoj> spoje;

  @override
  @JsonKey(name: "stationFrom")
  final String zeStanice;

  @JsonKey(name: "isRefunded")
  final bool vracena;

  @override
  @JsonKey(name: "price")
  @_CenaPrevodnik()
  final double cena;

  @override
  @JsonKey(name: "serviceClass")
  final Class trida;

  @JsonKey(name: "aztecImageUrl")
  final String qrUrl;

  @override
  @JsonKey(name: "transactionCode")
  final String id;

  factory CDJizdenka.fromJson(Map<String, dynamic> json) =>
      _$CDJizdenkaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$CDJizdenkaToJson(this);

  const CDJizdenka(
      {required this.doStanice,
      required this.jmeno,
      required this.platiOd,
      required this.platiDo,
      required this.spoje,
      required this.zeStanice,
      required this.vracena,
      required this.cena,
      required this.trida,
      required this.qrUrl,
      required this.id});
}

@JsonSerializable()
class CDSpoj implements Spoj {
  @override
  @JsonKey(name: "train")
  final String nazev;
  @override
  @JsonKey(name: "stationFrom")
  final String zeStanice;
  @override
  @JsonKey(name: "stationTo")
  final String doStanice;
  @override
  @JsonKey(name: "stationFromDate")
  @_DatumPlatnostiPrevodnik()
  final DateTime odjezdDen;
  @override
  @JsonKey(name: "stationToDate")
  @_DatumPlatnostiPrevodnik()
  final DateTime prijezdDen;

  const CDSpoj(
      {required this.nazev,
      required this.zeStanice,
      required this.doStanice,
      required this.odjezdDen,
      required this.prijezdDen});

  factory CDSpoj.fromJson(Map<String, dynamic> json) => _$CDSpojFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CDSpojToJson(this);
}

class _DatumPlatnostiPrevodnik implements JsonConverter<DateTime, String?> {
  const _DatumPlatnostiPrevodnik();
  @override
  DateTime fromJson(String? json) {
    if (json == null) {
      return DateTime.fromMillisecondsSinceEpoch(1);
    } else {
      var d = json.split(".");
      return DateTime.parse(
          "${d[2]}-${int.parse(d[1]) < 10 ? '0${d[1]}' : d[1]}-${int.parse(d[0]) < 10 ? '0${d[0]}' : d[0]}");
    }
  }

  @override
  String toJson(DateTime object) => object.toLocal().toIso8601String();
}

class _CenaPrevodnik implements JsonConverter<double, int> {
  const _CenaPrevodnik();
  @override
  double fromJson(int json) => json / 100;

  @override
  int toJson(double object) {
    try {
      return (object * 100) as int;
    } catch (e) {
      return -1;
    }
  }
}
