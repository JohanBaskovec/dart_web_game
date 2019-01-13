// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_solid_object_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildSolidObjectCommand _$BuildSolidObjectCommandFromJson(Map json) {
  return BuildSolidObjectCommand(
      _$enumDecodeNullable(_$SolidGameObjectTypeEnumMap, json['objectType']),
      json['position'] == null
          ? null
          : TilePosition.fromJson(json['position'] as Map))
    ..type = _$enumDecodeNullable(_$ClientCommandTypeEnumMap, json['type']);
}

Map<String, dynamic> _$BuildSolidObjectCommandToJson(
        BuildSolidObjectCommand instance) =>
    <String, dynamic>{
      'type': _$ClientCommandTypeEnumMap[instance.type],
      'objectType': _$SolidGameObjectTypeEnumMap[instance.objectType],
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

const _$SolidGameObjectTypeEnumMap = <SolidGameObjectType, dynamic>{
  SolidGameObjectType.tree: 'tree',
  SolidGameObjectType.appleTree: 'appleTree',
  SolidGameObjectType.coconutTree: 'coconutTree',
  SolidGameObjectType.ropeTree: 'ropeTree',
  SolidGameObjectType.leafTree: 'leafTree',
  SolidGameObjectType.barkTree: 'barkTree',
  SolidGameObjectType.player: 'player',
  SolidGameObjectType.woodenWall: 'woodenWall'
};

const _$ClientCommandTypeEnumMap = <ClientCommandType, dynamic>{
  ClientCommandType.login: 'login',
  ClientCommandType.move: 'move',
  ClientCommandType.useObjectOnSolidObject: 'useObjectOnSolidObject',
  ClientCommandType.buildSolidObject: 'buildSolidObject',
  ClientCommandType.unknown: 'unknown'
};
