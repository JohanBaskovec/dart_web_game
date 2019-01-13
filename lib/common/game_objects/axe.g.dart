// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'axe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Axe _$AxeFromJson(Map json) {
  return Axe()
    ..type = _$enumDecodeNullable(_$SoftObjectTypeEnumMap, json['type'])
    ..position = json['position'] == null
        ? null
        : WorldPosition.fromJson(json['position'] as Map)
    ..index = json['index'] as int;
}

Map<String, dynamic> _$AxeToJson(Axe instance) => <String, dynamic>{
      'type': _$SoftObjectTypeEnumMap[instance.type],
      'position': instance.position,
      'index': instance.index
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$SoftObjectTypeEnumMap = <SoftObjectType, dynamic>{
  SoftObjectType.stone: 'stone',
  SoftObjectType.axe: 'axe',
  SoftObjectType.log: 'log',
  SoftObjectType.hand: 'hand',
  SoftObjectType.apple: 'apple',
  SoftObjectType.fruitTreeLog: 'fruitTreeLog'
};
