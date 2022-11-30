// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ceskedrahy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CDJizdenka _$CDJizdenkaFromJson(Map<String, dynamic> json) => CDJizdenka(
      doStanice: json['stationTo'] as String,
      jmeno: json['name'] as String,
      platiOd: const _DatumPlatnostiPrevodnik()
          .fromJson(json['validFrom'] as String?),
      platiDo: const _DatumPlatnostiPrevodnik()
          .fromJson(json['validity'] as String?),
      spoje: (json['trainsThere'] as List<dynamic>)
          .map((e) => CDSpoj.fromJson(e as Map<String, dynamic>))
          .toList(),
      zeStanice: json['stationFrom'] as String,
      vracena: json['isRefunded'] as bool,
      cena: const _CenaPrevodnik().fromJson(json['price'] as int),
      trida: json['serviceClass'],
    );

Map<String, dynamic> _$CDJizdenkaToJson(CDJizdenka instance) =>
    <String, dynamic>{
      'stationTo': instance.doStanice,
      'name': instance.jmeno,
      'validity': const _DatumPlatnostiPrevodnik().toJson(instance.platiDo),
      'validFrom': const _DatumPlatnostiPrevodnik().toJson(instance.platiOd),
      'trainsThere': instance.spoje,
      'stationFrom': instance.zeStanice,
      'isRefunded': instance.vracena,
      'price': const _CenaPrevodnik().toJson(instance.cena),
      'serviceClass': instance.trida,
    };

CDSpoj _$CDSpojFromJson(Map<String, dynamic> json) => CDSpoj(
      nazev: json['train'] as String,
      zeStanice: json['stationFrom'] as String,
      doStanice: json['stationTo'] as String,
      odjezdDen: const _DatumPlatnostiPrevodnik()
          .fromJson(json['stationFromDate'] as String?),
      prijezdDen: const _DatumPlatnostiPrevodnik()
          .fromJson(json['stationToDate'] as String?),
    );

Map<String, dynamic> _$CDSpojToJson(CDSpoj instance) => <String, dynamic>{
      'train': instance.nazev,
      'stationFrom': instance.zeStanice,
      'stationTo': instance.doStanice,
      'stationFromDate':
          const _DatumPlatnostiPrevodnik().toJson(instance.odjezdDen),
      'stationToDate':
          const _DatumPlatnostiPrevodnik().toJson(instance.prijezdDen),
    };
