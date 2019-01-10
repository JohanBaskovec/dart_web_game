import 'package:dart_game_common/game_objects/game_object.dart';
import 'package:dart_game_common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'axe.g.dart';

@JsonSerializable()
class Axe extends GameObject {
  WorldPosition position;
  Axe(): super(GameObjectType.Axe);
}