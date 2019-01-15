// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_grid_aligned_entity_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddGridAlignedEntityCommand _$AddGridAlignedEntityCommandFromJson(Map json) {
  return AddGridAlignedEntityCommand(
      json['entity'] == null ? null : Entity.fromJson(json['entity'] as Map),
      json['collisionComponent'] == null
          ? null
          : CollisionComponent.fromJson(json['collisionComponent'] as Map),
      json['renderingComponent'] == null
          ? null
          : RenderingComponent.fromJson(json['renderingComponent'] as Map))
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$AddGridAlignedEntityCommandToJson(
        AddGridAlignedEntityCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'entity': instance.entity,
      'collisionComponent': instance.collisionComponent,
      'renderingComponent': instance.renderingComponent
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
