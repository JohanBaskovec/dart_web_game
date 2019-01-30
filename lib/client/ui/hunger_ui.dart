import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/session.dart';

class HungerUi {
  Box box = Box(left: 0, top:  0, width:  0, height:  0);
  Session session;

  HungerUi(this.session);

  void reinitialize(int screenWidth, int screenHeight) {
    box = Box(left: 20, top:  10, width:  100, height:  30);
  }
}