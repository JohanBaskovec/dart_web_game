import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world_position.g.dart';

@JsonSerializable(anyMap: true)
class WorldPosition {
  double x;
  double y;

  WorldPosition([this.x, this.y]);

  TilePosition toTilePosition() {
    return TilePosition(x ~/ tileSize, y ~/ tileSize);
  }

  /// Creates a new [WorldPosition] from a JSON object.
  static WorldPosition fromJson(Map<dynamic, dynamic> json) =>
      _$WorldPositionFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$WorldPositionToJson(this);
}
