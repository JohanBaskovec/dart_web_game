import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'solid_game_object.g.dart';

enum SolidGameObjectType {
  tree,
  appleTree,
  coconutTree,
  ropeTree,
  leafTree,
  barkTree,
}

@JsonSerializable(anyMap: true)
class SolidGameObject {
  SolidGameObjectType type;

  TilePosition position;

  SolidGameObject([this.type, this.position]);

  /// Creates a new [SolidGameObject] from a JSON object.
  static SolidGameObject fromJson(Map<dynamic, dynamic> json) =>
      _$SolidGameObjectFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SolidGameObjectToJson(this);
}