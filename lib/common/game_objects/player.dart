import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable(anyMap: true)
class Player {
  String name;
  TilePosition position;
  int id;

  Player([this.name, this.id]): position = TilePosition(0, 0);

  /// Creates a new [Player] from a JSON object.
  static Player fromJson(Map<dynamic, dynamic> json) =>
      _$PlayerFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}