// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_player_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemovePlayerCommand _$RemovePlayerCommandFromJson(Map json) {
  return RemovePlayerCommand(json['id'] as int)
    ..type = _$enumDecodeNullable(_$CommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$RemovePlayerCommandToJson(
        RemovePlayerCommand instance) =>
    <String, dynamic>{
      'type': _$CommandTypeEnumMap[instance.type],
      'id': instance.id
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
