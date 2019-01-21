import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';

class Window {
  Box box = Box(0, 0, 0, 0);
  bool contains(CanvasPosition position) {
    return box.pointIsInBox(position.x, position.y);
  }
}