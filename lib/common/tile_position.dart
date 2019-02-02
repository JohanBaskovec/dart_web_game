import 'dart:math';

import 'package:dart_game/common/constants.dart';

class TilePosition {
  // position of the tile in the tile map
  int x;
  int y;

  TilePosition(this.x, this.y);

  bool get isInWorldBound =>
      x >= 0 && x < worldTileSize && y >= 0 && y < worldTileSize;

  @override
  String toString() {
    return 'TilePosition{x: $x, y: $y}';
  }

  double distanceFrom(TilePosition other) {
    return sqrt(pow(other.x - x, 2) + pow(other.y - y, 2));
  }

  bool isAdjacentTo(TilePosition other) {
    return (other.x - x).abs() <= 1 && (other.y - y).abs() <= 1;
  }
}
