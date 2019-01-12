import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/tree.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'solid_game_object.g.dart';

enum SolidGameObjectType {
  tree,
  appleTree,
  coconutTree,
  ropeTree,
  leafTree,
  barkTree,
  player
}

@JsonSerializable(anyMap: true)
class SolidGameObject {
  SolidGameObjectType type;

  TilePosition _tilePosition;
  Inventory inventory;
  Box box;

  SolidGameObject([this.type, TilePosition tilePosition]) {
    this.tilePosition = tilePosition;
    inventory = Inventory();
  }

  /// Creates a new [SolidGameObject] from a JSON object.
  static SolidGameObject fromJson(Map<dynamic, dynamic> json) {
    final SolidGameObjectType type =
        _$enumDecode(_$SolidGameObjectTypeEnumMap, json['type']);
    switch (type) {
      case SolidGameObjectType.tree:
        return Tree.fromJson(json);
      case SolidGameObjectType.player:
        return Player.fromJson(json);
      case SolidGameObjectType.appleTree:
      case SolidGameObjectType.barkTree:
      case SolidGameObjectType.coconutTree:
      case SolidGameObjectType.leafTree:
      case SolidGameObjectType.ropeTree:
        throw Exception('Not implemented, should never happen.');
        break;
    }
    throw Exception('Null SolidGameObject type, should never happen!');
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SolidGameObjectToJson(this);

  TilePosition get tilePosition => _tilePosition;

  set tilePosition(TilePosition value) {
    _tilePosition = value;
    if (value != null) {
      box = Box(
          (tilePosition.x * tileSize).toDouble(),
          (tilePosition.y * tileSize).toDouble(),
          tileSize.toDouble(),
          tileSize.toDouble());
    }
  }
}
