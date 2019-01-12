// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_inventory_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToInventoryCommand _$AddToInventoryCommandFromJson(Map json) {
  return AddToInventoryCommand(
      json['playerId'] as int,
      json['object'] == null
          ? null
          : SoftGameObject.fromJson(json['object'] as Map))
    ..type = _$enumDecodeNullable(_$CommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$AddToInventoryCommandToJson(
        AddToInventoryCommand instance) =>
    <String, dynamic>{
      'type': _$CommandTypeEnumMap[instance.type],
      'playerId': instance.playerId,
      'object': instance.object
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

const _$CommandTypeEnumMap = <CommandType, dynamic>{
  CommandType.login: 'login',
  CommandType.loggedIn: 'loggedIn',
  CommandType.addPlayer: 'addPlayer',
  CommandType.removePlayer: 'removePlayer',
  CommandType.move: 'move',
  CommandType.useObjectOnSolidObject: 'useObjectOnSolidObject',
  CommandType.removeSolidObject: 'removeSolidObject',
  CommandType.addSolidObject: 'addSolidObject',
  CommandType.addToInventory: 'addToInventory',
  CommandType.removeFromInventory: 'removeFromInventory',
  CommandType.addSoftObject: 'addSoftObject',
  CommandType.removeSoftObject: 'removeSoftObject',
  CommandType.addTile: 'addTile',
  CommandType.removeTile: 'removeTile',
  CommandType.unknown: 'unknown'
};
