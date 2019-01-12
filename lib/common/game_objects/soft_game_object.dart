import 'package:dart_game/common/game_objects/axe.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'soft_game_object.g.dart';

enum SoftGameObjectType {
  stone,
  axe,
  log
}

/// Objects that can be traversed
@JsonSerializable(anyMap: true)
class SoftGameObject {
  SoftGameObjectType type;
  WorldPosition position;
  /// index in inventory if it's in one
  int index;

  SoftGameObject([this.type, this.position]);

  /// Creates a new [SoftGameObject] from a JSON object.
  static SoftGameObject fromJson(Map<dynamic, dynamic> json) {
    final type = _$enumDecode(_$SoftGameObjectTypeEnumMap, json['type']);
    switch (type) {
      case SoftGameObjectType.axe:
        return Axe.fromJson(json);
      case SoftGameObjectType.log:
      case SoftGameObjectType.stone:
        return _$SoftGameObjectFromJson(json);
        break;
    }
    throw Exception('Null SoftGameObject type, should never happen!');
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SoftGameObjectToJson(this);

  @override
  String toString() {
    return 'SoftGameObject{type: $type, position: $position, index: $index}';
  }


}