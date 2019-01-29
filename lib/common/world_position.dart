import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

class WorldPosition {
  double x;
  double y;

  WorldPosition([this.x, this.y]);

  TilePosition toTilePosition() {
    return TilePosition(x ~/ tileSize, y ~/ tileSize);
  }
}
