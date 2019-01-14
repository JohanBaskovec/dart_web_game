// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solid_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolidObject _$SolidObjectFromJson(Map json) {
  return SolidObject(
      _$enumDecodeNullable(_$SolidObjectTypeEnumMap, json['type']),
      json['tilePosition'] == null
          ? null
          : TilePosition.fromJson(json['tilePosition'] as Map))
    ..inventory = json['inventory'] == null
        ? null
        : Inventory.fromJson(json['inventory'] as Map)
    ..box = json['box'] == null ? null : Box.fromJson(json['box'] as Map)
    ..alive = json['alive'] as bool;
}

Map<String, dynamic> _$SolidObjectToJson(SolidObject instance) =>
    <String, dynamic>{
      'type': _$SolidObjectTypeEnumMap[instance.type],
      'inventory': instance.inventory,
      'box': instance.box,
      'alive': instance.alive,
      'tilePosition': instance.tilePosition
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

const _$SolidObjectTypeEnumMap = <SolidObjectType, dynamic>{
  SolidObjectType.tree: 'tree',
  SolidObjectType.appleTree: 'appleTree',
  SolidObjectType.coconutTree: 'coconutTree',
  SolidObjectType.ropeTree: 'ropeTree',
  SolidObjectType.leafTree: 'leafTree',
  SolidObjectType.barkTree: 'barkTree',
  SolidObjectType.player: 'player',
  SolidObjectType.woodenWall: 'woodenWall',
  SolidObjectType.campFire: 'campFire',
  SolidObjectType.basicTent: 'basicTent',
  SolidObjectType.bed: 'bed',
  SolidObjectType.woodenDoor: 'woodenDoor',
  SolidObjectType.woodenChest: 'woodenChest',
  SolidObjectType.ironDeposit: 'ironDeposit',
  SolidObjectType.ironMine: 'ironMine',
  SolidObjectType.goldDeposit: 'goldDeposit',
  SolidObjectType.goldMine: 'goldMine',
  SolidObjectType.foundry: 'foundry',
  SolidObjectType.oven: 'oven'
};
