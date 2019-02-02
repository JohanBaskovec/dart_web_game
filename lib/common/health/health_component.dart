import 'package:dart_game/common/health/body_part.dart';
import 'package:dart_game/common/health/body_part_status.dart';
import 'package:dart_game/common/health/body_part_type.dart';

class HealthComponent {
  List<BodyPart> rootBodyParts = [];
  List<BodyPart> allBodyParts = [];

  int ownerId;

  HealthComponent(
      this.rootBodyParts, this.allBodyParts, this.ownerId);

  HealthComponent.normalHumanBody(this.ownerId) {
    addBodyPart(BodyPart('Upper body', BodyPartType.upperBody, [
      BodyPart('Torso', BodyPartType.torso, [
        BodyPart('Left lung', BodyPartType.lung),
        BodyPart('Right lung', BodyPartType.lung),
        BodyPart('Heart', BodyPartType.heart),
      ]),
      BodyPart('Stomach', BodyPartType.stomach)
    ]));
    addBodyPart(BodyPart('Head', BodyPartType.head, [
      BodyPart('Left eye', BodyPartType.eye),
      BodyPart('Right eye', BodyPartType.eye),
      BodyPart('Jaw', BodyPartType.jaw),
    ]));
    addBodyPart(BodyPart('Right arm', BodyPartType.arm, [
      BodyPart('Right hand', BodyPartType.hand),
    ]));
    addBodyPart(BodyPart('Left arm', BodyPartType.arm, [
      BodyPart('Left hand', BodyPartType.hand),
    ]));
    addBodyPart(BodyPart('Left leg', BodyPartType.leg, [
      BodyPart('Left foot', BodyPartType.foot),
    ]));
    addBodyPart(BodyPart('Right leg', BodyPartType.leg, [
      BodyPart('Right foot', BodyPartType.foot),
    ]));
  }

  void addBodyPart(BodyPart bodyPart) {
    rootBodyParts.add(bodyPart);
    addPartToListRecursively(bodyPart);
  }

  void addPartToListRecursively(BodyPart bodyPart) {
    allBodyParts.add(bodyPart);
    bodyPart.parts.forEach(addPartToListRecursively);
  }

  void removePartFromListRecursively(BodyPart bodyPart) {
    allBodyParts.remove(bodyPart);
    bodyPart.parts.forEach(removePartFromListRecursively);
  }

  void attackBodyPart(BodyPart bodyPart, int attackStrength) {
    bodyPart.attack(attackStrength);
    print('Attacked random body part $bodyPart '
        'with attack strength $attackStrength.\n');
    if (bodyPart.status == BodyPartStatus.severed) {
      print('Body part has been severed.\n');
      removePartFromListRecursively(bodyPart);
    }
  }

  bool get alive {
    int nHealthyHearts = 0;
    int nHealthyLungs = 0;
    int nHealthyHeads = 0;
    for (BodyPart part in allBodyParts) {
      if (part.type == BodyPartType.heart) {
        nHealthyHearts++;
      } else if (part.type == BodyPartType.lung) {
        nHealthyLungs++;
      } else if (part.type == BodyPartType.head) {
        nHealthyHeads++;
      }
    }
    if (nHealthyHearts == 0 || nHealthyLungs == 0 || nHealthyHeads == 0) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'HealthComponent{rootBodyParts: $rootBodyParts, allBodyParts: $allBodyParts}';
  }
}
