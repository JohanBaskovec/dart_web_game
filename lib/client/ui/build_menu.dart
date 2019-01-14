import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/receipes.dart';
import 'package:dart_game/client/ui/button.dart';

class BuildMenuButton extends Button {
  /*
  EntityType type;

  BuildMenuButton(this.type);
  */
}

class BuildMenu {
  bool enabled = false;
  Box box = Box(0, 0, 0, 0);
  List<BuildMenuButton> buttons = [];
  /*
  EntityType selectedType;

  BuildMenu() {
    for (EntityType type in solidReceipes.keys) {
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
  */
}
