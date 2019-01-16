// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_grid_aligned_entity_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveGridAlignedEntityCommand _$MoveGridAlignedEntityCommandFromJson(Map json) {
  return MoveGridAlignedEntityCommand(
      json['entityId'] as int,
      json['destination'] == null
          ? null
          : TilePosition.fromJson(json['destination'] as Map))
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$MoveGridAlignedEntityCommandToJson(
        MoveGridAlignedEntityCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'entityId': instance.entityId,
      'destination': instance.destination
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