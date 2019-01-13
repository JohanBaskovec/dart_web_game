// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_message_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddMessageCommand _$AddMessageCommandFromJson(Map json) {
  return AddMessageCommand(
      json['message'] == null ? null : Message.fromJson(json['message'] as Map))
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$AddMessageCommandToJson(AddMessageCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'message': instance.message
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
  ServerCommandType.addMessage: 'addMessage',
  ServerCommandType.unknown: 'unknown'
};
