// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveCommand _$MoveCommandFromJson(Map json) {
  return MoveCommand(
      json['x'] as int, json['y'] as int, json['playerId'] as int)
    ..type = _$enumDecodeNullable(_$CommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$MoveCommandToJson(MoveCommand instance) =>
    <String, dynamic>{
      'type': _$CommandTypeEnumMap[instance.type],
      'x': instance.x,
      'y': instance.y,
      'playerId': instance.playerId
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
  CommandType.Login: 'Login',
  CommandType.LoggedIn: 'LoggedIn',
  CommandType.AddPlayer: 'AddPlayer',
  CommandType.RemovePlayer: 'RemovePlayer',
  CommandType.Move: 'Move',
  CommandType.Unknown: 'Unknown'
};