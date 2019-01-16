// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientCommand _$ClientCommandFromJson(Map json) {
  return ClientCommand(
      _$enumDecodeNullable(_$ClientCommandTypeEnumMap, json['type']));
}

Map<String, dynamic> _$ClientCommandToJson(ClientCommand instance) =>
    <String, dynamic>{'type': _$ClientCommandTypeEnumMap[instance.type]};

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
  ClientCommandType.useObjectOnEntity: 'useObjectOnEntity',
  ClientCommandType.buildEntity: 'buildEntity',
  ClientCommandType.sendMessage: 'sendMessage',
  ClientCommandType.click: 'click',
  ClientCommandType.unknown: 'unknown'
};
