import 'package:dart_game/common/age_component.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'soft_object.g.dart';

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
  fish
}

/// Objects that can be traversed
@JsonSerializable(anyMap: true)
class SoftObject {
  int id;
  SoftObjectType type;
  WorldPosition position;
  /// index in inventory if it's in one
  int indexInInventory;
  bool alive = true;

  AgeComponent _ageComponent;

  SoftObject([this.type, this.position]);

  /// Creates a new [SoftObject] from a JSON object.
  static SoftObject fromJson(Map<dynamic, dynamic> json) {
    final type = _$enumDecode(_$SoftObjectTypeEnumMap, json['type']);
    switch (type) {
      default:
        return _$SoftObjectFromJson(json);
        break;
    }
  }

  AgeComponent get ageComponent => _ageComponent;

  set ageComponent(AgeComponent value) {
    if (value == null) {
      return;
    }
    _ageComponent = value;
    _ageComponent.ownerId = id;
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SoftObjectToJson(this);

  @override
  String toString() {
    return 'SoftObject{id: $id, type: $type, position: $position, indexInInventory: $indexInInventory, alive: $alive, _ageComponent: $_ageComponent}';
  }


}