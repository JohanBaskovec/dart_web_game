import 'package:dart_game/common/box.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clickable_component.g.dart';

@JsonSerializable(anyMap: true)
class ClickableComponent {
  int id;
  Box box;

  ClickableComponent(this.box);

  /// Creates a new [ClickableComponent] from a JSON object.
  static ClickableComponent fromJson(Map<dynamic, dynamic> json) =>
      _$ClickableComponentFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$ClickableComponentToJson(this);
}
