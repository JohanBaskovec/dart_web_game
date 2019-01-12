// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Box _$BoxFromJson(Map json) {
  return Box(json['left'] as int, json['top'] as int, json['width'] as int,
      json['height'] as int)
    ..right = json['right'] as int
    ..bottom = json['bottom'] as int;
}

Map<String, dynamic> _$BoxToJson(Box instance) => <String, dynamic>{
      'left': instance.left,
      'right': instance.right,
      'top': instance.top,
      'bottom': instance.bottom,
      'width': instance.width,
      'height': instance.height
    };
