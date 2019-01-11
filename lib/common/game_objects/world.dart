import 'dart:math';

import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/game_objects/tree.dart';
import 'package:dart_game/common/size.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world.g.dart';

@JsonSerializable(anyMap: true)
class World {
  Size _dimension;
  List<List<Tile>> tilesColumn;
  List<List<SolidGameObject>> solidObjectColumns;
  List<Player> players;

  World();

  World.fromConstants(Random randomGenerator)
      : _dimension = worldSize,
        tilesColumn = List(worldSize.x),
        solidObjectColumns = List(worldSize.x),
        players = List(maxPlayers) {
    tilesColumn.fillRange(0, _dimension.x, List(_dimension.y));
    for (List<Tile> column in tilesColumn) {
      for (int i = 0; i < column.length; i++) {
        column[i] = Tile();
      }
    }

    solidObjectColumns.fillRange(0, _dimension.x, List(_dimension.y));
    for (int x = 0; x < solidObjectColumns.length; x++) {
      for (int y = 0; y < solidObjectColumns[x].length; y++) {
        if (randomGenerator.nextInt(100) < 10) {
          solidObjectColumns[x][y] = Tree(TilePosition(x, y));
        }
      }
    }
  }

  Size get dimension => _dimension;

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$WorldToJson(this);
}
