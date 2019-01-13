import 'package:dart_game/common/box.dart';

class InventoryMenu {
  Box box = Box(0, 0, 0, 0);

  void moveAndResize(Box box) {
    this.box = box;
  }
}