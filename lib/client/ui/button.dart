import 'package:dart_game/client/ui/ui_element.dart';

class Button extends UiElement {
  Function onLeftClick;

  Button();

  void leftClick() {
    if (onLeftClick != null) {
      onLeftClick();
    }
  }
}
