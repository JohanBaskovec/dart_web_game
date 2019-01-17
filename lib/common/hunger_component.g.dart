// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hunger_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HungerComponent _$HungerComponentFromJson(Map json) {
  return HungerComponent(
      json['hunger'] as int, json['increasePerSecond'] as int)
    ..ownerId = json['ownerId'] as int;
}

Map<String, dynamic> _$HungerComponentToJson(HungerComponent instance) =>
    <String, dynamic>{
      'hunger': instance.hunger,
      'increasePerSecond': instance.increasePerSecond,
      'ownerId': instance.ownerId
    };
