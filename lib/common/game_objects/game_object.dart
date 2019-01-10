import 'package:json_annotation/json_annotation.dart';

part 'game_object.g.dart';

enum GameObjectType {
  tree,
  appleTree,
  coconutTree,
  ropeTree,
  leafTree,
  barkTree,
  stone,
  axe
}

@JsonSerializable(anyMap: true)
class GameObject {
  GameObjectType type;

  GameObject(this.type);

  /// Creates a new [GameObject] from a JSON object.
  static GameObject fromJson(Map<dynamic, dynamic> json) =>
      _$GameObjectFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$GameObjectToJson(this);
}