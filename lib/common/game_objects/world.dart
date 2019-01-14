import 'dart:math';

import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/size.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world.g.dart';

@JsonSerializable(anyMap: true)
class World {
  Size _dimension;
  List<List<Tile>> tilesColumn = [];
  List<List<SolidObject>> solidObjectColumns = [];
  List<Player> players = [];

  World();

  World.fromConstants(Random randomGenerator)
      : _dimension = worldSize,
        tilesColumn = List(worldSize.x),
        solidObjectColumns = List(worldSize.x),
        players = List(maxPlayers) {
    for (int x = 0 ; x < _dimension.x ; x++) {
      tilesColumn[x] = List(_dimension.y);
    }
    for (List<Tile> column in tilesColumn) {
      for (int i = 0; i < column.length; i++) {
        column[i] = Tile();
      }
    }

    for (int x = 0 ; x < _dimension.x ; x++) {
      solidObjectColumns[x] = List(_dimension.y);
    }
    for (int x = 0; x < solidObjectColumns.length; x++) {
      for (int y = 0; y < solidObjectColumns[x].length; y++) {
        final int rand = randomGenerator.nextInt(100);
        if (rand < 10) {
          final tree = SolidObject(SolidObjectType.tree, TilePosition(x, y));
          final int nLogs = randomGenerator.nextInt(6) + 1;
          for (int i = 0 ; i < nLogs ; i++) {
            tree.inventory.addItem(SoftGameObject(SoftObjectType.log));
          }
          final int nLeaves = randomGenerator.nextInt(6) + 1;
          for (int i = 0 ; i < nLeaves ; i++) {
            tree.inventory.addItem(SoftGameObject(SoftObjectType.leaves));
          }
          final int nSnakes = randomGenerator.nextInt(6) + 1;
          for (int i = 0 ; i < nSnakes ; i++) {
            tree.inventory.addItem(SoftGameObject(SoftObjectType.snake));
          }
          solidObjectColumns[x][y] = tree;
        } else if (rand < 20) {
          final tree = SolidObject(SolidObjectType.appleTree, TilePosition(x, y));
          final int nLogs = randomGenerator.nextInt(6) + 1;
          for (int i = 0 ; i < nLogs ; i++) {
            tree.inventory.addItem(SoftGameObject(SoftObjectType.fruitTreeLog));
          }
          final int nApples = randomGenerator.nextInt(6) + 1;
          for (int i = 0 ; i < nLogs ; i++) {
            tree.inventory.addItem(SoftGameObject(SoftObjectType.apple));
          }
          solidObjectColumns[x][y] = tree;
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
