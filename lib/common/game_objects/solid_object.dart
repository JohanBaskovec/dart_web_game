import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'solid_object.g.dart';

enum SolidObjectType {
  tree,
  appleTree,
  coconutTree,
  ropeTree,
  leafTree,
  barkTree,
  player,
  woodenWall
}

@JsonSerializable(anyMap: true)
class SolidObject {
  SolidObjectType type;

  TilePosition _tilePosition;
  Inventory inventory;
  Box box;
  bool alive = true;

  SolidObject([this.type, TilePosition tilePosition]) {
    this.tilePosition = tilePosition;
    inventory = Inventory();
  }

  SoftGameObject useItem(SoftGameObject item) {
    switch (type) {
      case SolidObjectType.tree:
        if (item.type == SoftObjectType.axe) {
          final itemFromInventory = inventory.popFirstOfType(SoftObjectType.log);
          if (itemFromInventory.itemsLeft == 0) {
            alive = false;
          }
        }
        break;
      case SolidObjectType.appleTree:
          if (item.type == SoftObjectType.hand) {
            final InventoryPopResult result = inventory.popFirstOfType(SoftObjectType.apple);
            if (result != null) {
              print('picked ${result.object}');
              return result.object;
            } else {
              return null;
            }
          }
        break;
      default:
        break;
    }
    return null;
  }

  /// Creates a new [SolidObject] from a JSON object.
  static SolidObject fromJson(Map<dynamic, dynamic> json) {
    final SolidObjectType type =
        _$enumDecode(_$SolidObjectTypeEnumMap, json['type']);
    switch (type) {
      case SolidObjectType.player:
        return Player.fromJson(json);
      default:
        return _$SolidObjectFromJson(json);
    }
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SolidObjectToJson(this);

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
