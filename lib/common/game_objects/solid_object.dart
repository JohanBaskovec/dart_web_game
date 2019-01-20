import 'dart:math';

import 'package:dart_game/common/age_component.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/hunger_component.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
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
  box
}

@JsonSerializable(anyMap: true)
class SolidObject {
  SolidObjectType type;
  int _id;

  int get id => _id;

  void set id(int value) {
    _id = value;
    if (_ageComponent != null) {
      _ageComponent.ownerId = _id;
    }
    if (_hungerComponent != null) {
      _hungerComponent.ownerId = _id;
    }
    if (_inventory != null) {
      _inventory.ownerId = _id;
    }
  }

  String name;

  int ownerId;

  @JsonKey(ignore: true)
  GameClient client;

  TilePosition _tilePosition;

  /// Inventory that can be accessed by using your hand on an object
  /// Example: fruits from trees, items from chests
  Inventory _inventory;

  Inventory get inventory => _inventory;

  set inventory(Inventory value) {
    if (value == null) {
      return;
    }
    value.ownerId = id;
    _inventory = value;
  }

  /// Inventory that contains objects that can be gathered by using a tool
  /// Example: iron from an iron vein, wood logs from a tree
  int nGatherableItems;
  Box box;
  bool alive = true;
  HungerComponent _hungerComponent;
  AgeComponent _ageComponent;

  SolidObject([this.type, TilePosition tilePosition]) {
    this.tilePosition = tilePosition;
    switch (type) {
      case SolidObjectType.box:
        inventory = Inventory();
        break;
      default:
        break;
    }
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
      box = Box(tilePosition.x * tileSize, tilePosition.y * tileSize, tileSize,
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

  @override
  String toString() {
    return 'SolidObject{type: $type, id: $id, name: $name, _tilePosition: $_tilePosition, inventory: $inventory, nGatherableItems: $nGatherableItems, box: $box, alive: $alive, _hungerComponent: $_hungerComponent, _ageComponent: $_ageComponent}';
  }

  double distanceFrom(SolidObject other) {
    return sqrt(pow(other.tilePosition.x - tilePosition.x, 2) +
        pow(other.tilePosition.y - tilePosition.y, 2));
  }

  bool isAdjacentTo(SolidObject other) {
    return isAdjacentToPosition(other.tilePosition);
  }

  bool isAdjacentToPosition(TilePosition position) {
    return position.distanceFrom(tilePosition) < 2;
  }
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
  final player = SolidObject(SolidObjectType.player, TilePosition(x, y));
  player.ageComponent = AgeComponent(100 * minutesPerYear);
  player.inventory = Inventory();
  player.inventory.private = true;
  return player;
}
