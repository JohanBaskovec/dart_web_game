import 'dart:math';

import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/size.dart';
import 'package:dart_game/common/tile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world.g.dart';

@JsonSerializable(anyMap: true)
class World {
  Size _dimension;
  List<List<Tile>> tilesColumn = [];
  List<List<SolidObject>> solidObjectColumns = [];
  List<SolidObject> players = [];
  List<SolidObject> solidObjects = List(worldSize.x * worldSize.y);
  List<SoftGameObject> softObjects = [];
  List<int> freeSoftObjectIds = [];

  World();

  void addSoftObject(SoftGameObject object) {
    if (freeSoftObjectIds.isEmpty) {
      object.id = softObjects.length;
      softObjects.add(object);
    } else {
      final int id = freeSoftObjectIds.removeLast();
      object.id = id;
      softObjects[id] = object;
    }
  }

  void removeSoftObject(SoftGameObject object) {
    freeSoftObjectIds.add(object.id);
    softObjects.removeAt(object.id);
  }

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
          final tree = makeTree(x, y);
          solidObjects.add(tree);
          final int nLeaves = randomGenerator.nextInt(6) + 1;
          for (int i = 0 ; i < nLeaves ; i++) {
            final leaves = SoftGameObject(SoftObjectType.leaves);
            addSoftObject(leaves);
            tree.inventory.addItem(leaves);
          }

          final int nSnakes = randomGenerator.nextInt(6) + 1;
          for (int i = 0 ; i < nSnakes ; i++) {
            final snake = SoftGameObject(SoftObjectType.leaves);
            addSoftObject(snake);
            tree.inventory.addItem(snake);
          }
          solidObjectColumns[x][y] = tree;
        } else if (rand < 20) {
          final tree = makeAppleTree(x, y);
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
