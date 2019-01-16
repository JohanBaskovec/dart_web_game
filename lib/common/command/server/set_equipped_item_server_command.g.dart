// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_equipped_item_server_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetEquippedItemServerCommand _$SetEquippedItemServerCommandFromJson(Map json) {
  return SetEquippedItemServerCommand(json['itemId'] as int)
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$SetEquippedItemServerCommandToJson(
        SetEquippedItemServerCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'itemId': instance.itemId
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
  ServerCommandType.removeSolidObject: 'removeSolidObject',
  ServerCommandType.addSolidObject: 'addSolidObject',
  ServerCommandType.moveSolidObject: 'moveSolidObject',
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
