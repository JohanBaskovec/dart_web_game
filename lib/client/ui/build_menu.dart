import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/session.dart';

class BuildMenuButton extends Button {
  SolidObjectType type;

  BuildMenuButton(this.type);
}

class BuildIngredientsButton extends Button {
  int itemId;

  BuildIngredientsButton(this.itemId);
}

class BuildMenu extends UiElement {
  List<BuildMenuButton> buttons = [];
  Session session;

  SolidObjectType selectedType;

  BuildMenu() : super() {
    for (SolidObjectType type in buildingRecipes.keys) {
      buttons.add(BuildMenuButton(type));
    }
  }

  @override
  set box(Box value) {
    super.box = value;
    for (var i = 0; i < buttons.length; i++) {
      buttons[i].box =
          Box(left: box.left, top: box.top + 40 * i, width: 40, height: 40);
    }
  }

  bool leftClickAt(CanvasPosition canvasPosition) {
    for (BuildMenuButton button in buttons) {
      if (button.box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        print('clicking on button ${button.type}\n');
        selectedType = button.type;
        return true;
      }
    }
    return false;
  }
}

