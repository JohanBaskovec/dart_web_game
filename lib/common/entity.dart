import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable(anyMap: true)
class Entity {
  int id;
  int renderingComponentId;
  int publicInventoryId;
  int privateInventoryId;
  int usableComponentId;
  int collisionComponentId;
  EntityType type;
  int clickableComponentId;

  Entity(this.id, this.type);

  /// Creates a new [Entity] from a JSON object.
  static Entity fromJson(Map<dynamic, dynamic> json) =>
      _$EntityFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$EntityToJson(this);
}