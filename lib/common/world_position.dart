import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'world_position.g.dart';

@JsonSerializable(anyMap: true)
class WorldPosition {
  int x;
  int y;

  WorldPosition([this.x, this.y]);

  num distanceFrom(WorldPosition b) {
    return sqrt(pow(b.x - x, 2) + pow(b.y - y, 2)).abs();
  }
  
  /// Creates a new [WorldPosition] from a JSON object.
  static WorldPosition fromJson(Map<dynamic, dynamic> json) =>
      _$WorldPositionFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$WorldPositionToJson(this);
}
