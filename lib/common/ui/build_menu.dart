import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/receipes.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/ui/button.dart';

class BuildMenuButton extends Button {
  SolidGameObjectType type;

  BuildMenuButton(this.type);
}

class BuildMenu {
  bool enabled = false;
  Box box = Box(0, 0, 0, 0);
  List<Button> buttons = [];
  SolidGameObjectType selectedType;

  BuildMenu() {
    for (SolidGameObjectType type in solidReceipes.keys) {
      buttons.add(BuildMenuButton(type));
    }
  }

  void moveAndResize(Box box) {
    for (var i = 0 ; i < buttons.length ; i++) {
      buttons[i].box = Box(box.left, box.top + 40 * i, 40, 40);
    }
    this.box = box;
  }

  bool clickAt(CanvasPosition canvasPosition) {
    for (BuildMenuButton button in buttons) {
      if (button.box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        print('clicking on button ${button.type}');
        selectedType = button.type;
        return false;
      }
    }
    return true;
  }
}
