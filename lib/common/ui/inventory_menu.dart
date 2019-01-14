import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/ui/player_inventory_menu.dart';

class InventoryMenu {
  Box box = Box(0, 0, 0, 0);
  List<InventoryButton> buttons = [];
  SolidObject owner;
  Player player;

  InventoryMenu(Box box, this.owner, this.player) {
    moveAndResize(box);
  }
  void moveAndResize(Box box) {
    this.box = box;
    final double widthPerStack = box.width / 9;
    buttons = [];
    for (var i = 0; i < owner.inventory.stacks.length; i++) {
      final double left = box.left + i * widthPerStack + box.left;
      final newButton = InventoryButton(owner.inventory.stacks[i]);
      newButton.box = Box(left, box.top, widthPerStack, box.height);
      buttons.add(newButton);
    }
  }

  bool clickAt(CanvasPosition canvasPosition) {
    for (int i = 0 ; i < buttons.length ; i++) {
      if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        player.inventory.addItem(buttons[i].stack.removeLast());
        if (buttons[i].stack.isEmpty) {
          buttons.removeAt(i);
        }
        return false;
      }
    }
    return true;
  }
}