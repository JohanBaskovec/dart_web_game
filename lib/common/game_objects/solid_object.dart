import 'package:dart_game/common/age_component.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/hunger_component.dart';
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
  int id;
  String name;

  TilePosition _tilePosition;

  /// Inventory that can be accessed by using your hand on an object
  /// Example: fruits from trees, items from chests
  Inventory inventory;

  /// Inventory that contains objects that can be gathered by using a tool
  /// Example: iron from an iron vein, wood logs from a tree
  int nGatherableItems;
  Box box;
  bool alive = true;
  HungerComponent _hungerComponent;
  AgeComponent _ageComponent;

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
    box.moveTo(position.x * tileSize, position.y * tileSize);
  }

  TilePosition get tilePosition => _tilePosition;

  set tilePosition(TilePosition value) {
    _tilePosition = value;
    if (value != null) {
      box = Box(
          tilePosition.x * tileSize,
          tilePosition.y * tileSize,
          tileSize,
          tileSize);
    }
  }

  HungerComponent get hungerComponent => _hungerComponent;

  set hungerComponent(HungerComponent value) {
    if (value == null) {
      return;
    }
    _hungerComponent = value;
    value.ownerId = id;
  }

  AgeComponent get ageComponent => _ageComponent;

  set ageComponent(AgeComponent value) {
    if (value == null) {
      return;
    }
    _ageComponent = value;
    _ageComponent.ownerId = id;
  }

  /// Creates a new [SolidObject] from a JSON object.
  static SolidObject fromJson(Map<dynamic, dynamic> json) =>
      _$SolidObjectFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SolidObjectToJson(this);
}

const int minutesPerYear = 525600;
SolidObject makeTree(int x, int y) {
  final tree = SolidObject(SolidObjectType.tree, TilePosition(x, y));
  tree.ageComponent = AgeComponent(1000 * minutesPerYear);
  tree.inventory = Inventory();
  tree.nGatherableItems = 1;
  return tree;
}

SolidObject makeAppleTree(int x, int y) {
  final tree = SolidObject(SolidObjectType.appleTree, TilePosition(x, y));
  tree.ageComponent = AgeComponent(1000 * minutesPerYear);
  tree.inventory = Inventory();
  tree.nGatherableItems = 1;
  return tree;
}

SolidObject makePlayer(int x, int y) {
  final tree = SolidObject(SolidObjectType.player, TilePosition(x, y));
  tree.ageComponent = AgeComponent(100 * minutesPerYear);
  tree.inventory = Inventory();
  return tree;
}
