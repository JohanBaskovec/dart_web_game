// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map json) {
  return Player(json['name'] as String, json['id'] as int)
    ..position = json['position'] == null
        ? null
        : TilePosition.fromJson(json['position'] as Map);
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'id': instance.id
    };
