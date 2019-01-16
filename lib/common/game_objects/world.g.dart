// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

World _$WorldFromJson(Map json) {
  return World()
    ..renderingComponents = (json['renderingComponents'] as List)
        ?.map((e) => e == null ? null : RenderingComponent.fromJson(e as Map))
        ?.toList()
    ..renderingComponentFreeIds = (json['renderingComponentFreeIds'] as List)
        ?.map((e) => e as int)
        ?.toList()
    ..collisionComponents = (json['collisionComponents'] as List)
        ?.map((e) => e == null ? null : CollisionComponent.fromJson(e as Map))
        ?.toList()
    ..collisionComponentFreeIds = (json['collisionComponentFreeIds'] as List)
        ?.map((e) => e as int)
        ?.toList()
    ..entities = (json['entities'] as List)
        ?.map((e) => e == null ? null : Entity.fromJson(e as Map))
        ?.toList()
    ..entitiesFreeIds =
        (json['entitiesFreeIds'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$WorldToJson(World instance) => <String, dynamic>{
      'renderingComponents': instance.renderingComponents,
      'renderingComponentFreeIds': instance.renderingComponentFreeIds,
      'collisionComponents': instance.collisionComponents,
      'collisionComponentFreeIds': instance.collisionComponentFreeIds,
      'entities': instance.entities,
      'entitiesFreeIds': instance.entitiesFreeIds
    };
