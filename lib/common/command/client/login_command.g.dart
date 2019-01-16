// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginCommand _$LoginCommandFromJson(Map json) {
  return LoginCommand(json['name'] as String, json['id'] as int)
    ..type = _$enumDecodeNullable(_$ClientCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$LoginCommandToJson(LoginCommand instance) =>
    <String, dynamic>{
      'type': _$ClientCommandTypeEnumMap[instance.type],
      'name': instance.name,
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

const _$ClientCommandTypeEnumMap = <ClientCommandType, dynamic>{
  ClientCommandType.login: 'login',
  ClientCommandType.move: 'move',
  ClientCommandType.useObjectOnSolidObject: 'useObjectOnSolidObject',
  ClientCommandType.buildSolidObject: 'buildSolidObject',
  ClientCommandType.sendMessage: 'sendMessage',
  ClientCommandType.takeFromInventory: 'takeFromInventory',
  ClientCommandType.addToInventory: 'addToInventory',
  ClientCommandType.unknown: 'unknown'
};
