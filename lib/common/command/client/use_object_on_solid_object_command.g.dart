// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_object_on_solid_object_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UseObjectOnSolidObjectCommand _$UseObjectOnSolidObjectCommandFromJson(
    Map json) {
  return UseObjectOnSolidObjectCommand(
      json['targetPosition'] == null
          ? null
          : TilePosition.fromJson(json['targetPosition'] as Map),
      json['itemIndex'] as int)
    ..type = _$enumDecodeNullable(_$ClientCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$UseObjectOnSolidObjectCommandToJson(
        UseObjectOnSolidObjectCommand instance) =>
    <String, dynamic>{
      'type': _$ClientCommandTypeEnumMap[instance.type],
      'targetPosition': instance.targetPosition,
      'itemIndex': instance.itemIndex
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
  ClientCommandType.unknown: 'unknown'
};
