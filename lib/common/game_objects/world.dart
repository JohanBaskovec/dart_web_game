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


  World.fromConstants()
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
  }

  Size get dimension => _dimension;

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$WorldToJson(this);
}
