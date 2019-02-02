import 'package:dart_game/common/health/body_part_status.dart';
import 'package:dart_game/common/health/body_part_type.dart';

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

  @override
  String toString() {
    return 'BodyPart{health: $health, parts: $parts, status: $status, type: $type, name: $name}';
  }
}
