import 'package:dart_game/common/game_objects/world.dart';

class AgeComponent {
  int maxAge;
  int ageMinutes = 0;
  int ownerId;

  AgeComponent(this.maxAge);

  void update(World world) {
    assert(ownerId != null);
    if (ageMinutes >= maxAge) {
      //world.solidObjects[ownerId].alive = false;
    }
  }
}
