import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tile.g.dart';

enum TileType { grass, dirt }

@JsonSerializable(anyMap: true)
class Tile {
  TileType tileType;
  List<int> itemsOnGround = [];

  @JsonKey(ignore: true)
  Box box;
  @JsonKey(ignore: true)
  TilePosition position;

  Tile(this.tileType);

  /// Creates a new [Tile] from a JSON object.
  static Tile fromJson(Map<dynamic, dynamic> json) => _$TileFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TileToJson(this);

  @override
  String toString() {
    return 'Tile{tileType: $tileType, box: $box, position: $position}';
  }
}
