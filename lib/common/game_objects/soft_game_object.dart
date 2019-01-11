import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'soft_game_object.g.dart';

enum SoftGameObjectType {
  stone,
  axe
}

/// Objects that can be traversed
@JsonSerializable(anyMap: true)
class SoftGameObject {
  SoftGameObjectType type;
  WorldPosition position;

  SoftGameObject([this.type, this.position]);

  /// Creates a new [SoftGameObject] from a JSON object.
  static SoftGameObject fromJson(Map<dynamic, dynamic> json) =>
      _$SoftGameObjectFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SoftGameObjectToJson(this);
}