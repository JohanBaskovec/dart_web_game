import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rendering_component.g.dart';

@JsonSerializable(anyMap: true)
class RenderingComponent {
  EntityType image;
  Box box;

  RenderingComponent(this.image, this.box);

  /// Creates a new [RenderingComponent] from a JSON object.
  static RenderingComponent fromJson(Map<dynamic, dynamic> json) =>
      _$RenderingComponentFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RenderingComponentToJson(this);
}