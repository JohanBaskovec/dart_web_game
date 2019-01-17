import 'dart:math';

import 'package:dart_game/common/constants.dart';
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
  List<List<int>> solidObjectColumns = [];
  List<SolidObject> solidObjects = List(worldSize.x * worldSize.y);
  List<int> freeSolidObjectIds = [];
  List<SoftObject> softObjects = [];
  List<int> freeSoftObjectIds = [];

  World();


  World.fromConstants()
      : _dimension = worldSize,
        tilesColumn = List(worldSize.x),
        solidObjectColumns = List(worldSize.x) {
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
    for (int i = 0 ; i < _dimension.x * _dimension.y ; i++) {
      freeSolidObjectIds.add(i);
    }
  }

  Size get dimension => _dimension;

  SolidObject getObjectAt(TilePosition position) {
    if (solidObjectColumns[position.x][position.y] == null) {
      return null;
    }
    return solidObjects[solidObjectColumns[position.x][position.y]];
  }

  SolidObject getSolidObject(int id) {
    return solidObjects[id];
  }

  SoftObject getSoftObject(int id) {
    return softObjects[id];
  }

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$WorldToJson(this);
}
