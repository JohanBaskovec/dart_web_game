import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';

class UiElement {
  Box _box = Box(0, 0, 0, 0);
  bool visible = true;
  bool contains(CanvasPosition position) {
    return _box.pointIsInBox(position.x, position.y);
  }

  void toggleVisible() => visible = !visible;

  set box(Box value) => _box = value;

  Box get box => _box;
}