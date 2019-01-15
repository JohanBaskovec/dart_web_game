// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collision_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollisionComponent _$CollisionComponentFromJson(Map json) {
  return CollisionComponent(
      json['box'] == null ? null : Box.fromJson(json['box'] as Map))
    ..id = json['id'] as int;
}

Map<String, dynamic> _$CollisionComponentToJson(CollisionComponent instance) =>
    <String, dynamic>{'id': instance.id, 'box': instance.box};
