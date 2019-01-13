// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map json) {
  return Player(
      json['tilePosition'] == null
          ? null
          : TilePosition.fromJson(json['tilePosition'] as Map),
      json['name'] as String,
      json['id'] as int)
    ..type = _$enumDecodeNullable(_$SolidGameObjectTypeEnumMap, json['type'])
    ..inventory = json['inventory'] == null
        ? null
        : Inventory.fromJson(json['inventory'] as Map)
    ..box = json['box'] == null ? null : Box.fromJson(json['box'] as Map);
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'type': _$SolidGameObjectTypeEnumMap[instance.type],
      'inventory': instance.inventory,
      'box': instance.box,
      'tilePosition': instance.tilePosition,
      'name': instance.name,
      'id': instance.id
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

const _$SolidGameObjectTypeEnumMap = <SolidGameObjectType, dynamic>{
  SolidGameObjectType.tree: 'tree',
  SolidGameObjectType.appleTree: 'appleTree',
  SolidGameObjectType.coconutTree: 'coconutTree',
  SolidGameObjectType.ropeTree: 'ropeTree',
  SolidGameObjectType.leafTree: 'leafTree',
  SolidGameObjectType.barkTree: 'barkTree',
  SolidGameObjectType.player: 'player',
  SolidGameObjectType.woodenWall: 'woodenWall'
};
