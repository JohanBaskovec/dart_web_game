import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/client/ui/button.dart';

class BuildMenuButton extends Button {
  SolidObjectType type;

  BuildMenuButton(this.type);
}

class BuildMenu {
  bool enabled = false;
  Box box = Box(0, 0, 0, 0);
  List<BuildMenuButton> buttons = [];
  SolidObjectType selectedType;

  BuildMenu() {
    for (SolidObjectType type in buildingRecipes.keys) {
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
        print('clicking on button ${button.type}\n');
        selectedType = button.type;
        return false;
      }
    }
    return true;
  }
}
