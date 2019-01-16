// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_player_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPlayerCommand _$AddPlayerCommandFromJson(Map json) {
  return AddPlayerCommand(
      json['player'] == null ? null : Player.fromJson(json['player'] as Map))
    ..type = _$enumDecodeNullable(_$ServerCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$AddPlayerCommandToJson(AddPlayerCommand instance) =>
    <String, dynamic>{
      'type': _$ServerCommandTypeEnumMap[instance.type],
      'player': instance.player
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
  ServerCommandType.removeEntity: 'removeEntity',
  ServerCommandType.addEntity: 'addEntity',
  ServerCommandType.addToInventory: 'addToInventory',
  ServerCommandType.removeFromInventory: 'removeFromInventory',
  ServerCommandType.addSoftObject: 'addSoftObject',
  ServerCommandType.removeSoftObject: 'removeSoftObject',
  ServerCommandType.addTile: 'addTile',
  ServerCommandType.removeTile: 'removeTile',
  ServerCommandType.addMessage: 'addMessage',
  ServerCommandType.unknown: 'unknown'
};
