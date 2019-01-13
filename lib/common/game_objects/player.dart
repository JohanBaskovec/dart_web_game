// unused but necessary for player.g.dart!
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable(anyMap: true)
class Player extends SolidGameObject {
  String name;
  int id;

  Player([TilePosition tilePosition, this.name, this.id])
      : super(SolidGameObjectType.player, tilePosition);

  void move(int x, int y) {
    tilePosition.x += x;
    tilePosition.y += y;
    box.move(x * tileSize, y * tileSize);
  }

  void moveTo(TilePosition position) {
    tilePosition = position;
  }

  /// Creates a new [Player] from a JSON object.
  static Player fromJson(Map<dynamic, dynamic> json) => _$PlayerFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
