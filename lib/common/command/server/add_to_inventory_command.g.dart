// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_inventory_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToInventoryCommand _$AddToInventoryCommandFromJson(Map json) {
  return AddToInventoryCommand(json['objectId'] as int)
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$AddToInventoryCommandToJson(
        AddToInventoryCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'objectId': instance.objectId
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
  ServerCommandType.addPlayer: 'addPlayer',
  ServerCommandType.removePlayer: 'removePlayer',
  ServerCommandType.movePlayer: 'movePlayer',
  ServerCommandType.removeSolidObject: 'removeSolidObject',
  ServerCommandType.addSolidObject: 'addSolidObject',
  ServerCommandType.addToInventory: 'addToInventory',
  ServerCommandType.removeFromInventory: 'removeFromInventory',
  ServerCommandType.addSoftObject: 'addSoftObject',
  ServerCommandType.removeSoftObject: 'removeSoftObject',
  ServerCommandType.addTile: 'addTile',
  ServerCommandType.removeTile: 'removeTile',
  ServerCommandType.setEquippedItem: 'setEquippedItem',
  ServerCommandType.addMessage: 'addMessage',
  ServerCommandType.unknown: 'unknown'
};
