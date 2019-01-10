// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'axe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Axe _$AxeFromJson(Map<String, dynamic> json) {
  return Axe()
    ..type = _$enumDecodeNullable(_$GameObjectTypeEnumMap, json['type'])
    ..position = json['position'] == null
        ? null
        : WorldPosition.fromJson(json['position'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AxeToJson(Axe instance) => <String, dynamic>{
      'type': _$GameObjectTypeEnumMap[instance.type],
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

const _$GameObjectTypeEnumMap = <GameObjectType, dynamic>{
  GameObjectType.Tree: 'Tree',
  GameObjectType.AppleTree: 'AppleTree',
  GameObjectType.CoconutTree: 'CoconutTree',
  GameObjectType.RopeTree: 'RopeTree',
  GameObjectType.LeafTree: 'LeafTree',
  GameObjectType.BarkTree: 'BarkTree',
  GameObjectType.Stone: 'Stone',
  GameObjectType.Axe: 'Axe'
};
