import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'solid_object.g.dart';


@JsonSerializable(anyMap: true)
class Entity {
  EntityType type;
  int id;

  Entity([this.id, this.type]);

  /// Creates a new [Entity] from a JSON object.
  static Entity fromJson(Map<dynamic, dynamic> json) {
    final EntityType type =
        _$enumDecode(_$EntityTypeEnumMap, json['type']);
    switch (type) {
      case EntityType.player:
        return Player.fromJson(json);
      default:
        return _$EntityFromJson(json);
    }
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$EntityToJson(this);

  TilePosition get tilePosition => _tilePosition;

  set tilePosition(TilePosition value) {
    _tilePosition = value;
    if (value != null) {
      box = Box(
          (tilePosition.x * tileSize).toDouble(),
          (tilePosition.y * tileSize).toDouble(),
          tileSize.toDouble(),
          tileSize.toDouble());
    }
  }
}
