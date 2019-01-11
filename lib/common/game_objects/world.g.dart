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
            ?.map((e) => e == null ? null : SolidGameObject.fromJson(e as Map))
            ?.toList())
        ?.toList()
    ..players = (json['players'] as List)
        ?.map((e) => e == null ? null : Player.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$WorldToJson(World instance) => <String, dynamic>{
      'tilesColumn': instance.tilesColumn,
      'solidObjectColumns': instance.solidObjectColumns,
      'players': instance.players
    };
