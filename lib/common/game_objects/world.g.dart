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
            ?.map((e) => e == null ? null : Entity.fromJson(e as Map))
            ?.toList())
        ?.toList()
    ..players = (json['players'] as List)
        ?.map((e) => e == null ? null : Player.fromJson(e as Map))
        ?.toList()
    ..publicInventories = (json['publicInventories'] as List)
        ?.map((e) => e == null ? null : Inventory.fromJson(e as Map))
        ?.toList()
    ..privateInventories = (json['privateInventories'] as List)
        ?.map((e) => e == null ? null : Inventory.fromJson(e as Map))
        ?.toList()
    ..boxes = (json['boxes'] as List)
        ?.map((e) => e == null ? null : Box.fromJson(e as Map))
        ?.toList()
    ..positions = (json['positions'] as List)
        ?.map((e) => e == null ? null : WorldPosition.fromJson(e as Map))
        ?.toList()
    ..entities = (json['entities'] as List)
        ?.map((e) => e == null ? null : Entity.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$WorldToJson(World instance) => <String, dynamic>{
      'tilesColumn': instance.tilesColumn,
      'solidObjectColumns': instance.solidObjectColumns,
      'players': instance.players,
      'publicInventories': instance.publicInventories,
      'privateInventories': instance.privateInventories,
      'boxes': instance.boxes,
      'positions': instance.positions,
      'entities': instance.entities
    };
