import 'package:json_annotation/json_annotation.dart';

enum Dopravce { ceskeDrahy, regioJet }

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
  const Jizdenka(
      {required this.jmeno,
      required this.dopravce,
      required this.platiOd,
      required this.platiDo,
      required this.spoje,
      required this.zeStanice,
      required this.doStanice,
      required this.cena,
      required this.trida});
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
