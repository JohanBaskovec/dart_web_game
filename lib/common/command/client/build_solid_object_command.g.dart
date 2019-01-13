// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_solid_object_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildSolidObjectCommand _$BuildSolidObjectCommandFromJson(Map json) {
  return BuildSolidObjectCommand(
      _$enumDecodeNullable(_$SolidObjectTypeEnumMap, json['objectType']),
      json['position'] == null
          ? null
          : TilePosition.fromJson(json['position'] as Map))
    ..type = _$enumDecodeNullable(_$ClientCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$BuildSolidObjectCommandToJson(
        BuildSolidObjectCommand instance) =>
    <String, dynamic>{
      'type': _$ClientCommandTypeEnumMap[instance.type],
      'objectType': _$SolidObjectTypeEnumMap[instance.objectType],
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

const _$SolidObjectTypeEnumMap = <SolidObjectType, dynamic>{
  SolidObjectType.tree: 'tree',
  SolidObjectType.appleTree: 'appleTree',
  SolidObjectType.coconutTree: 'coconutTree',
  SolidObjectType.ropeTree: 'ropeTree',
  SolidObjectType.leafTree: 'leafTree',
  SolidObjectType.barkTree: 'barkTree',
  SolidObjectType.player: 'player',
  SolidObjectType.woodenWall: 'woodenWall'
};

const _$ClientCommandTypeEnumMap = <ClientCommandType, dynamic>{
  ClientCommandType.login: 'login',
  ClientCommandType.move: 'move',
  ClientCommandType.useObjectOnSolidObject: 'useObjectOnSolidObject',
  ClientCommandType.buildSolidObject: 'buildSolidObject',
  ClientCommandType.sendMessage: 'sendMessage',
  ClientCommandType.unknown: 'unknown'
};
