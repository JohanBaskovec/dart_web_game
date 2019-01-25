import 'dart:math';

import 'package:dart_game/common/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tile_position.g.dart';

@JsonSerializable(anyMap: true)
class TilePosition {
  // position of the tile in the tile map
  int x;
  int y;

  TilePosition(this.x, this.y);

  bool get isInWorldBound =>
      x >= 0 && x < worldSize.x && y >= 0 && y < worldSize.y;

  /// Creates a new [TilePosition] from a JSON object.
  static TilePosition fromJson(Map<dynamic, dynamic> json) =>
      _$TilePositionFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$TilePositionToJson(this);

  @override
  String toString() {
    return 'TilePosition{x: $x, y: $y}';
  }

  double distanceFrom(TilePosition other) {
    return sqrt(pow(other.x - x, 2) + pow(other.y - y, 2));
  }
}
