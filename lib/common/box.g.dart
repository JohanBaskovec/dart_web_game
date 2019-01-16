// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Box _$BoxFromJson(Map json) {
  return Box(
      (json['left'] as num)?.toDouble(),
      (json['top'] as num)?.toDouble(),
      (json['width'] as num)?.toDouble(),
      (json['height'] as num)?.toDouble())
    ..right = (json['right'] as num)?.toDouble()
    ..bottom = (json['bottom'] as num)?.toDouble();
}

Map<String, dynamic> _$BoxToJson(Box instance) => <String, dynamic>{
      'left': instance.left,
      'right': instance.right,
      'top': instance.top,
      'bottom': instance.bottom,
      'width': instance.width,
      'height': instance.height
    };
