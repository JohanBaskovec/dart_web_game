// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clickable_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClickableComponent _$ClickableComponentFromJson(Map json) {
  return ClickableComponent(
      json['box'] == null ? null : Box.fromJson(json['box'] as Map))
    ..id = json['id'] as int;
}

Map<String, dynamic> _$ClickableComponentToJson(ClickableComponent instance) =>
    <String, dynamic>{'id': instance.id, 'box': instance.box};
