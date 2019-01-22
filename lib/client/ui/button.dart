import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/common/box.dart';

class Button extends UiElement {
  Function onLeftClick;

  Button([Box box]): super(box);

  void leftClick() {
    if (onLeftClick != null) {
      onLeftClick();
    }
  }

  void tryLeftClick(CanvasPosition canvasPosition) {
    if (box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
      leftClick();
    }
  }
}
