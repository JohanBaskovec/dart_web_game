import 'package:dart_game_common/game_objects/game_object.dart';
import 'package:dart_game_common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tree.g.dart';

@JsonSerializable()
class Tree extends GameObject {
  TilePosition position;
  Tree(): super(GameObjectType.Tree);
}