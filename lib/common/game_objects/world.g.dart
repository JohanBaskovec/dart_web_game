// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

World _$WorldFromJson(Map json) {
  return World()
    ..tilesColumn = (json['tilesColumn'] as List)
        ?.map((e) => (e as List)
            ?.map((e) => e == null ? null : Tile.fromJson(e as Map))
            ?.toList())
        ?.toList()
    ..solidObjectColumns = (json['solidObjectColumns'] as List)
        ?.map((e) => (e as List)
            ?.map((e) => e == null ? null : SolidObject.fromJson(e as Map))
            ?.toList())
        ?.toList()
    ..players = (json['players'] as List)
        ?.map((e) => e == null ? null : SolidObject.fromJson(e as Map))
        ?.toList()
    ..solidObjects = (json['solidObjects'] as List)
        ?.map((e) => e == null ? null : SolidObject.fromJson(e as Map))
        ?.toList()
    ..softObjects = (json['softObjects'] as List)
        ?.map((e) => e == null ? null : SoftObject.fromJson(e as Map))
        ?.toList()
    ..freeSoftObjectIds =
        (json['freeSoftObjectIds'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$WorldToJson(World instance) => <String, dynamic>{
      'tilesColumn': instance.tilesColumn,
      'solidObjectColumns': instance.solidObjectColumns,
      'players': instance.players,
      'solidObjects': instance.solidObjects,
      'softObjects': instance.softObjects,
      'freeSoftObjectIds': instance.freeSoftObjectIds
    };
