import 'package:dart_game/common/age_component.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/food_component.dart';
import 'package:dart_game/common/player_skills.dart';
import 'package:dart_game/common/world_position.dart';

enum SoftObjectType {
  stone,
  axe,
  log,
  hand,
  apple,
  fruitTreeLog,
  bowl,
  bandage,
  soap,
  knife,
  sword,
  shield,
  bag,
  pickaxe,
  spider,
  cricket,
  potato,
  snake,
  leaves,
  bow,
  arrow,
  string,
  rope,
  fiber,
  bone,
  tooth,
  spear,
  banana,
  worm,
  bread,
  rice,
  fish,
  cookedSnake
}

class SoftObject {
  int id;
  int ownerId;
  SoftObjectType type;
  WorldPosition _position;

  WorldPosition get position => _position;

  set position(WorldPosition value) {
    _position = value;
    if (value == null) {
      box = null;
      return;
    }
    box = Box(
        left: _position.x.toInt(),
        top: _position.y.toInt(),
        width: 20,
        height: 20);
  }

  /// index in inventory if it's in one
  int indexInInventory;

  bool get inInventory => indexInInventory != null;

  bool alive = true;
  double quality;
  Box box;

  AgeComponent _ageComponent;
  FoodComponent foodComponent;

  SoftObject(this.quality, this.type, [this._position]);

  AgeComponent get ageComponent => _ageComponent;

  set ageComponent(AgeComponent value) {
    if (value == null) {
      return;
    }
    _ageComponent = value;
    _ageComponent.ownerId = id;
  }

  bool get isWeapon {
    return weaponTypeToSkillMap[type] != null;
  }

  @override
  String toString() {
    return 'SoftObject{id: $id, type: $type, position: $position, indexInInventory: $indexInInventory, alive: $alive, _ageComponent: $_ageComponent, foodComponent: $foodComponent}';
  }
}
