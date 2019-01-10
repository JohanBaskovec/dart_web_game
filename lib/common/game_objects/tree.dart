import 'package:dart_game/common/game_objects/game_object.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tree.g.dart';

@JsonSerializable(anyMap: true)
class Tree extends GameObject {
  TilePosition position;
  Tree(): super(GameObjectType.Tree);

  /// Creates a new [Tree] from a JSON object.
  static Tree fromJson(Map<dynamic, dynamic> json) =>
      _$TreeFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TreeToJson(this);
}