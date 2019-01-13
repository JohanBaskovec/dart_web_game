import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/ui/button.dart';

class InventoryButton extends Button {
  List<SoftGameObject> stack;

  InventoryButton(this.stack);
}

class InventoryMenu {
  Box box = Box(0, 0, 0, 0);
  List<InventoryButton> buttons = [];
  Player player;

  InventoryMenu();

  void moveAndResize(Box box) {
    this.box = box;
  }

  bool clickAt(CanvasPosition canvasPosition) {
    for (int i = 0 ; i < buttons.length ; i++) {
      if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        player.inventory.currentlyEquiped = buttons[i].stack[0];
        return false;
      }
    }
    return true;
  }

  void update() {
    final double widthPerStack = box.width / 9;
    buttons = [];
    for (var i = 0; i < player.inventory.stacks.length; i++) {
      final double left = i * widthPerStack + box.left;
      final newButton = InventoryButton(player.inventory.stacks[i]);
      newButton.box = Box(left, box.top, widthPerStack, box.height);
      buttons.add(newButton);
    }
  }
}