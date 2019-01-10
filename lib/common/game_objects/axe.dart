import 'package:dart_game/common/game_objects/game_object.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'axe.g.dart';

@JsonSerializable(anyMap: true)
class Axe extends GameObject {
  WorldPosition position;
  Axe(): super(GameObjectType.Axe);
  
  /// Creates a new [Axe] from a JSON object.
  static Axe fromJson(Map<dynamic, dynamic> json) =>
      _$AxeFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AxeToJson(this);
}