import 'dart:math';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/entity.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/size.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world.g.dart';

@JsonSerializable(anyMap: true)
class World {
  Size _dimension;
  List<List<Tile>> tilesColumn = [];
  List<List<Entity>> solidObjectColumns = [];
  List<Player> players = [];
  List<Inventory> publicInventories = [];
  List<Inventory> privateInventories = [];
  List<Box> boxes = [];
  List<WorldPosition> positions = [];
  List<Entity> entities = [];

  World();

  World.fromConstants(Random randomGenerator)
      : _dimension = worldSize,
        tilesColumn = List(worldSize.x),
        solidObjectColumns = List(worldSize.x),
        players = List(maxPlayers) {
    for (int x = 0; x < _dimension.x; x++) {
      tilesColumn[x] = List(_dimension.y);
    }
    for (List<Tile> column in tilesColumn) {
      for (int i = 0; i < column.length; i++) {
        column[i] = Tile();
      }
    }

    for (int x = 0; x < _dimension.x; x++) {
      solidObjectColumns[x] = List(_dimension.y);
    }
    for (int x = 0; x < solidObjectColumns.length; x++) {
      for (int y = 0; y < solidObjectColumns[x].length; y++) {
        final int rand = randomGenerator.nextInt(100);
        if (rand < 10) {
          final tree = Entity(EntityType.tree, TilePosition(x, y));
          final int nLogs = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLogs; i++) {
            tree.inventory.addItem(Entity(EntityType.log));
          }
          final int nLeaves = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLeaves; i++) {
            tree.inventory.addItem(Entity(EntityType.leaves));
          }
          final int nSnakes = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nSnakes; i++) {
            tree.inventory.addItem(Entity(EntityType.snake));
          }
          solidObjectColumns[x][y] = tree;
        } else if (rand < 20) {
          final tree = Entity(EntityType.appleTree, TilePosition(x, y));
          final int nLogs = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLogs; i++) {
            tree.inventory.addItem(Entity(EntityType.fruitTreeLog));
          }
          final int nApples = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLogs; i++) {
            tree.inventory.addItem(Entity(EntityType.apple));
          }
          solidObjectColumns[x][y] = tree;
        }
      }
    }
  }

  Entity useItem(Entity source, Entity target) {
    final WorldPosition position = positions[target.id];
    final TilePosition tilePosition = TilePosition(
        (position.x / tileSize).floor(), (position.y / tileSize).floor());
    switch (target.type) {
      case EntityType.tree:
        if (source.type == EntityType.axe) {
          final itemFromInventory =
              privateInventories[target.id].popFirstOfType(EntityType.log);
          if (itemFromInventory != null) {
            if (itemFromInventory.itemsLeft == 0) {
              solidObjectColumns[tilePosition.x][tilePosition.y] = null;
            }
            return itemFromInventory.object;
          }
        }
        break;
      default:
        break;
    }
    return null;
  }

  Size get dimension => _dimension;

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$WorldToJson(this);
}
