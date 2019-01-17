import 'package:dart_game/common/game_objects/world.dart';
import 'package:json_annotation/json_annotation.dart';

part 'age_component.g.dart';

@JsonSerializable(anyMap: true)
class AgeComponent {
  int maxAge;
  int ageMinutes = 0;
  int ownerId;

  AgeComponent(this.maxAge);

  void update(World world) {
    if (ageMinutes >= maxAge) {
      world.solidObjects[ownerId].alive = false;
    }
  }

  /// Creates a new [AgeComponent] from a JSON object.
  static AgeComponent fromJson(Map<dynamic, dynamic> json) =>
      _$AgeComponentFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$AgeComponentToJson(this);
}