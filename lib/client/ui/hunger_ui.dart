import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/session.dart';

class HungerUi {
  Box box = Box(0, 0, 0, 0);
  Session session;

  HungerUi(this.session);

  void reinitialize(int screenWidth, int screenHeight) {
    box = Box(20, 10, 100, 30);
  }
}