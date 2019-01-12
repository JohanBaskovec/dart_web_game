// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_solid_object_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveSolidObjectCommand _$RemoveSolidObjectCommandFromJson(Map json) {
  return RemoveSolidObjectCommand(json['position'] == null
      ? null
      : TilePosition.fromJson(json['position'] as Map))
    ..type = _$enumDecodeNullable(_$CommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$RemoveSolidObjectCommandToJson(
        RemoveSolidObjectCommand instance) =>
    <String, dynamic>{
      'type': _$CommandTypeEnumMap[instance.type],
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
