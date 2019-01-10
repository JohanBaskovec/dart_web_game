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

@JsonSerializable()
class GameObject {
  GameObjectType type;

  GameObject(this.type);
}