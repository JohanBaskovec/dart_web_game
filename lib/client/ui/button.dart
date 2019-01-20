import 'package:dart_game/common/box.dart';

class Button {
  Box box;

  Button();

  void moveAndResize(Box box) {
    this.box = box;
  }

}
