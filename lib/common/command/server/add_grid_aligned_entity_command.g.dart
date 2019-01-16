// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_grid_aligned_entity_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddGridAlignedEntityCommand _$AddGridAlignedEntityCommandFromJson(Map json) {
  return AddGridAlignedEntityCommand()
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type'])
    ..entityId = json['entityId'] as int
    ..image = _$enumDecodeNullable(_$EntityTypeEnumMap, json['image'])
    ..position = json['position'] == null
        ? null
        : TilePosition.fromJson(json['position'] as Map);
}

Map<String, dynamic> _$AddGridAlignedEntityCommandToJson(
        AddGridAlignedEntityCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'entityId': instance.entityId,
      'image': _$EntityTypeEnumMap[instance.image],
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

const _$ServerCommandTypeEnumMap = <ServerCommandType, dynamic>{
  ServerCommandType.loggedIn: 'loggedIn',
  ServerCommandType.addEntity: 'addEntity',
  ServerCommandType.addEntityWithRendering: 'addEntityWithRendering',
  ServerCommandType.addGridAlignedEntity: 'addGridAlignedEntity',
  ServerCommandType.moveGridAlignedEntity: 'moveGridAlignedEntity',
  ServerCommandType.removeEntity: 'removeEntity',
  ServerCommandType.addToInventory: 'addToInventory',
  ServerCommandType.removeFromInventory: 'removeFromInventory',
  ServerCommandType.addRenderingComponent: 'addRenderingComponent',
  ServerCommandType.removeRenderingComponent: 'removeRenderingComponent',
  ServerCommandType.addMessage: 'addMessage',
  ServerCommandType.unknown: 'unknown'
};

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
