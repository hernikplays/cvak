import 'package:json_annotation/json_annotation.dart';

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

enum Dopravce {
  @JsonValue("CESKEDRAHY")
  ceskeDrahy,
  @JsonValue("REGIOJET")
  regioJet
}

abstract class Jizdenka {
  final Dopravce dopravce;
  final DateTime platiOd;
  final DateTime platiDo;
  final List<Spoj> spoje;
  final String zeStanice;
  final String doStanice;
  final String jmeno;
  final double cena;
  final Class trida;
  final String id;
  const Jizdenka(
      {required this.jmeno,
      required this.dopravce,
      required this.platiOd,
      required this.platiDo,
      required this.spoje,
      required this.zeStanice,
      required this.doStanice,
      required this.cena,
      required this.trida,
      required this.id});

  factory Jizdenka.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

abstract class Spoj {
  final String nazev;
  final String zeStanice;
  final String doStanice;
  final DateTime odjezdDen;
  final DateTime prijezdDen;
  const Spoj(
      {required this.nazev,
      required this.zeStanice,
      required this.doStanice,
      required this.odjezdDen,
      required this.prijezdDen});
}

enum Class {
  @JsonValue("Class2")
  class2,
  @JsonValue("Class1")
  class1,
  @JsonValue("Business")
  business
}
