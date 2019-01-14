import 'package:dart_game/common/game_objects/axe.dart';
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
class SoftGameObject {
  SoftObjectType type;
  WorldPosition position;
  /// index in inventory if it's in one
  int index;

  SoftGameObject([this.type, this.position]);

  /// Creates a new [SoftGameObject] from a JSON object.
  static SoftGameObject fromJson(Map<dynamic, dynamic> json) {
    final type = _$enumDecode(_$SoftObjectTypeEnumMap, json['type']);
    switch (type) {
      case SoftObjectType.axe:
        return Axe.fromJson(json);
      default:
        return _$SoftGameObjectFromJson(json);
        break;
    }
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SoftGameObjectToJson(this);

  @override
  String toString() {
    return 'SoftGameObject{type: $type, position: $position, index: $index}';
  }


}