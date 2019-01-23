import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/common/box.dart';

class Button extends UiElement {
  Function onLeftClick;
  Function onShiftLeftClick;
  Function onRightClick;

  Button([Box box]): super(box);

  void leftClick() {
    if (onLeftClick != null) {
      onLeftClick();
    }
  }

  bool tryLeftClick(CanvasPosition canvasPosition) {
    if (box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
      leftClick();
      return true;
    }
    return false;
  }

  void rightClick() {
    if (onRightClick != null) {
      onRightClick();
    }
  }

  bool tryRightClick(CanvasPosition canvasPosition) {
    if (box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
      rightClick();
      return true;
    }
    return false;
  }

  void shiftLeftClick() {
    if (onShiftLeftClick != null) {
      onShiftLeftClick();
    }
  }

  bool tryShiftLeftClick(CanvasPosition canvasPosition) {
    if (box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
      shiftLeftClick();
      return true;
    }
    return false;
  }
}
