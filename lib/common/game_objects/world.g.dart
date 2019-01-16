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
        ?.map((e) => (e as List)?.map((e) => e as int)?.toList())
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
    ..worldPositions = (json['worldPositions'] as List)
        ?.map((e) => e == null ? null : WorldPosition.fromJson(e as Map))
        ?.toList()
    ..gridPositions = (json['gridPositions'] as List)
        ?.map((e) => e == null ? null : TilePosition.fromJson(e as Map))
        ?.toList()
    ..entities = (json['entities'] as List)?.map((e) => e as int)?.toList()
    ..renderingComponents = (json['renderingComponents'] as List)
        ?.map((e) => e == null ? null : RenderingComponent.fromJson(e as Map))
        ?.toList()
    ..usableComponents = (json['usableComponents'] as List)
        ?.map((e) => e == null ? null : UsableComponent.fromJson(e as Map))
        ?.toList();
}

Map<String, dynamic> _$WorldToJson(World instance) => <String, dynamic>{
      'tilesColumn': instance.tilesColumn,
      'solidObjectColumns': instance.solidObjectColumns,
      'publicInventories': instance.publicInventories,
      'privateInventories': instance.privateInventories,
      'boxes': instance.boxes,
      'worldPositions': instance.worldPositions,
      'gridPositions': instance.gridPositions,
      'entities': instance.entities,
      'renderingComponents': instance.renderingComponents,
      'usableComponents': instance.usableComponents
    };
