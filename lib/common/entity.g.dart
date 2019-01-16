// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map json) {
  return Entity(json['id'] as int,
      _$enumDecodeNullable(_$EntityTypeEnumMap, json['type']))
    ..renderingComponentId = json['renderingComponentId'] as int
    ..publicInventoryId = json['publicInventoryId'] as int
    ..privateInventoryId = json['privateInventoryId'] as int
    ..usableComponentId = json['usableComponentId'] as int
    ..collisionComponentId = json['collisionComponentId'] as int
    ..clickableComponentId = json['clickableComponentId'] as int;
}

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'id': instance.id,
      'renderingComponentId': instance.renderingComponentId,
      'publicInventoryId': instance.publicInventoryId,
      'privateInventoryId': instance.privateInventoryId,
      'usableComponentId': instance.usableComponentId,
      'collisionComponentId': instance.collisionComponentId,
      'type': _$EntityTypeEnumMap[instance.type],
      'clickableComponentId': instance.clickableComponentId
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

const _$EntityTypeEnumMap = <EntityType, dynamic>{
  EntityType.tree: 'tree',
  EntityType.appleTree: 'appleTree',
  EntityType.coconutTree: 'coconutTree',
  EntityType.ropeTree: 'ropeTree',
  EntityType.leafTree: 'leafTree',
  EntityType.barkTree: 'barkTree',
  EntityType.player: 'player',
  EntityType.woodenWall: 'woodenWall',
  EntityType.campFire: 'campFire',
  EntityType.basicTent: 'basicTent',
  EntityType.bed: 'bed',
  EntityType.woodenDoor: 'woodenDoor',
  EntityType.woodenChest: 'woodenChest',
  EntityType.ironDeposit: 'ironDeposit',
  EntityType.ironMine: 'ironMine',
  EntityType.goldDeposit: 'goldDeposit',
  EntityType.goldMine: 'goldMine',
  EntityType.foundry: 'foundry',
  EntityType.oven: 'oven',
  EntityType.stone: 'stone',
  EntityType.axe: 'axe',
  EntityType.log: 'log',
  EntityType.hand: 'hand',
  EntityType.apple: 'apple',
  EntityType.fruitTreeLog: 'fruitTreeLog',
  EntityType.bowl: 'bowl',
  EntityType.bandage: 'bandage',
  EntityType.soap: 'soap',
  EntityType.knife: 'knife',
  EntityType.sword: 'sword',
  EntityType.shield: 'shield',
  EntityType.bag: 'bag',
  EntityType.pickaxe: 'pickaxe',
  EntityType.spider: 'spider',
  EntityType.cricket: 'cricket',
  EntityType.potato: 'potato',
  EntityType.snake: 'snake',
  EntityType.leaves: 'leaves',
  EntityType.bow: 'bow',
  EntityType.arrow: 'arrow',
  EntityType.string: 'string',
  EntityType.rope: 'rope',
  EntityType.fiber: 'fiber',
  EntityType.bone: 'bone',
  EntityType.tooth: 'tooth',
  EntityType.spear: 'spear',
  EntityType.banana: 'banana',
  EntityType.worm: 'worm',
  EntityType.bread: 'bread',
  EntityType.rice: 'rice',
  EntityType.fish: 'fish'
};
