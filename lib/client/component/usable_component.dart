
import 'package:json_annotation/json_annotation.dart';

part 'usable_component.g.dart';

@JsonSerializable(anyMap: true)
class UsableComponent {
  /// Creates a new [UsableComponent] from a JSON object.
  static UsableComponent fromJson(Map<dynamic, dynamic> json) =>
      _$UsableComponentFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$UsableComponentToJson(this);
}