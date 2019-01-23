import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';

abstract class UiElement {
  Box _box;
  bool visible = true;

  UiElement([this._box]);

  bool contains(CanvasPosition position) {
    return _box.pointIsInBox(position.x, position.y);
  }

  void toggleVisible() => visible = !visible;

  set box(Box value) => _box = value;

  Box get box => _box;
}