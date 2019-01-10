// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tree _$TreeFromJson(Map json) {
  return Tree()
    ..type = _$enumDecodeNullable(_$GameObjectTypeEnumMap, json['type'])
    ..position = json['position'] == null
        ? null
        : TilePosition.fromJson(json['position'] as Map);
}

Map<String, dynamic> _$TreeToJson(Tree instance) => <String, dynamic>{
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
  GameObjectType.tree: 'tree',
  GameObjectType.appleTree: 'appleTree',
  GameObjectType.coconutTree: 'coconutTree',
  GameObjectType.ropeTree: 'ropeTree',
  GameObjectType.leafTree: 'leafTree',
  GameObjectType.barkTree: 'barkTree',
  GameObjectType.stone: 'stone',
  GameObjectType.axe: 'axe'
};
