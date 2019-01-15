import 'package:dart_game/common/box.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collision_component.g.dart';

@JsonSerializable(anyMap: true)
class CollisionComponent {
  int id;
  Box box;

  CollisionComponent(this.box);

  /// Creates a new [CollisionComponent] from a JSON object.
  static CollisionComponent fromJson(Map<dynamic, dynamic> json) =>
      _$CollisionComponentFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$CollisionComponentToJson(this);
}
