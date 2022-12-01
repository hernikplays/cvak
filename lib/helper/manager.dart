import 'dart:convert';
import 'dart:io';

import 'package:cvak/api/ceskedrahy.dart';
import 'package:cvak/api/jizdenka.dart';
import 'package:path_provider/path_provider.dart';

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

class ManazerJizdenek {
  static void ulozitJizdenku(Jizdenka j) {
    var typ = "";
    if (j is CDJizdenka) {
      typ = "cd";
    } else {
      typ = "local";
    }
    var data = {
      "type": typ,
      "data": {...j.toJson()}
    };
    getApplicationDocumentsDirectory().then((d) =>
        File("${d.path}/j_${j.id}.json").writeAsStringSync(jsonEncode(data)));
  }

  static List<Jizdenka> nahratJizdenky() {
    var jizdenky = <Jizdenka>[];
    getApplicationDocumentsDirectory().then((d) {
      for (var file in Directory(d.path).listSync()) {
        if (!file.path.endsWith(".json")) return;
        var data = jsonDecode((file as File).readAsStringSync());
        if (data["type"] == "cd") {
          jizdenky.add(CDJizdenka.fromJson(data["data"]));
        }
      }
    });
    return jizdenky;
  }
}
