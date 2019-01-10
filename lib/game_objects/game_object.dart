import 'package:json_annotation/json_annotation.dart';

part 'game_object.g.dart';

enum GameObjectType {
  Tree,
  AppleTree,
  CoconutTree,
  RopeTree,
  LeafTree,
  BarkTree,
  Stone,
  Axe
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