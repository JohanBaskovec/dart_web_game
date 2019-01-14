// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_entity_with_rendering_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddEntityWithRenderingCommand _$AddEntityWithRenderingCommandFromJson(
    Map json) {
  return AddEntityWithRenderingCommand()
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type'])
    ..entityId = json['entityId'] as int
    ..rendering = json['rendering'] == null
        ? null
        : RenderingComponent.fromJson(json['rendering'] as Map);
}

Map<String, dynamic> _$AddEntityWithRenderingCommandToJson(
        AddEntityWithRenderingCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'entityId': instance.entityId,
      'rendering': instance.rendering
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
