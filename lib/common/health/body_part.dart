import 'package:dart_game/common/health/body_part_status.dart';
import 'package:dart_game/common/health/body_part_type.dart';
import 'package:json_annotation/json_annotation.dart';
part 'body_part.g.dart';

@JsonSerializable(anyMap: true)
class BodyPart {
  int health;
  List<BodyPart> parts;
  BodyPartStatus status;
  BodyPartType type;
  String name;

  BodyPart(this.name, this.type, [this.parts]): health = 100, status = BodyPartStatus.healthy {
    parts ??= [];
  }

  void attack(int attackStrength) {
    health -= attackStrength;
    if (health == 100) {
      status = BodyPartStatus.healthy;
    } else if (health > 0) {
      status = BodyPartStatus.damaged;
    } else {
      status = BodyPartStatus.severed;
    }
  }

  /// Creates a new [BodyPart] from a JSON object.
  static BodyPart fromJson(Map<dynamic, dynamic> json) =>
      _$BodyPartFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$BodyPartToJson(this);

  @override
  String toString() {
    return 'BodyPart{health: $health, parts: $parts, status: $status, type: $type, name: $name}';
  }
}
