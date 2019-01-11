// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soft_game_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoftGameObject _$SoftGameObjectFromJson(Map json) {
  return SoftGameObject(
      _$enumDecodeNullable(_$SoftGameObjectTypeEnumMap, json['type']),
      json['position'] == null
          ? null
          : WorldPosition.fromJson(json['position'] as Map));
}

Map<String, dynamic> _$SoftGameObjectToJson(SoftGameObject instance) =>
    <String, dynamic>{
      'type': _$SoftGameObjectTypeEnumMap[instance.type],
      'position': instance.position
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

const _$SoftGameObjectTypeEnumMap = <SoftGameObjectType, dynamic>{
  SoftGameObjectType.stone: 'stone',
  SoftGameObjectType.axe: 'axe'
};
