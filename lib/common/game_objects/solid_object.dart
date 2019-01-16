import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
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
  woodenWall,
  campFire,
  basicTent,
  bed,
  woodenDoor,
  woodenChest,
  ironDeposit,
  ironMine,
  goldDeposit,
  goldMine,
  foundry,
  oven,
}

@JsonSerializable(anyMap: true)
class SolidObject {
  SolidObjectType type;
  String name;

  TilePosition _tilePosition;

  /// Inventory that can be accessed by using your hand on an object
  /// Example: fruits from trees, items from chests
  Inventory publicInventory;

  /// Inventory that contains objects that can be gathered by using a tool
  /// Example: iron from an iron vein, wood logs from a tree
  Inventory privateInventory;
  Box box;
  bool alive = true;

  SolidObject([this.type, TilePosition tilePosition]) {
    this.tilePosition = tilePosition;
  }

  void move(int x, int y) {
    tilePosition.x += x;
    tilePosition.y += y;
    box.move(x * tileSize, y * tileSize);
  }

  void moveTo(TilePosition position) {
    tilePosition = position;
  }

  SoftGameObject useItem(SoftGameObject item) {
    switch (type) {
      case SolidObjectType.tree:
      case SolidObjectType.appleTree:
        if (item.type == SoftObjectType.axe) {
          final itemFromInventory =
              privateInventory.popFirstOfType(SoftObjectType.log);
          if (itemFromInventory != null) {
            if (itemFromInventory.itemsLeft == 0) {
              alive = false;
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

  /// Creates a new [SolidObject] from a JSON object.
  static SolidObject fromJson(Map<dynamic, dynamic> json) =>
      _$SolidObjectFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SolidObjectToJson(this);
}

SolidObject makeTree(int x, int y) {
  final tree = SolidObject(SolidObjectType.tree, TilePosition(x, y));
  tree.privateInventory = Inventory();
  tree.publicInventory = Inventory();
  return tree;
}

SolidObject makeAppleTree(int x, int y) {
  final tree = SolidObject(SolidObjectType.appleTree, TilePosition(x, y));
  tree.privateInventory = Inventory();
  tree.publicInventory = Inventory();
  return tree;
}

SolidObject makePlayer(int x, int y) {
  final tree = SolidObject(SolidObjectType.player, TilePosition(x, y));
  tree.privateInventory = Inventory();
  return tree;
}
