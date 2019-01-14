import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';

class InventoryMenu {
  Box box = Box(0, 0, 0, 0);
  List<InventoryButton> buttons = [];
  int ownerId;
  int playerId;

  InventoryMenu(Box box, this.ownerId, this.playerId) {
    moveAndResize(box);
  }
  void moveAndResize(Box box) {
    /*
    this.box = box;
    final double widthPerStack = box.width / 9;
    buttons = [];
    for (var i = 0; i < ownerId.inventory.stacks.length; i++) {
      final double left = box.left + i * widthPerStack + box.left;
      final newButton = InventoryButton(ownerId.inventory.stacks[i]);
      newButton.box = Box(left, box.top, widthPerStack, box.height);
      buttons.add(newButton);
    }
    */
  }

  bool clickAt(CanvasPosition canvasPosition) {
    /*
    for (int i = 0 ; i < buttons.length ; i++) {
      if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        playerId.inventory.addItem(buttons[i].stack.removeLast());
        if (buttons[i].stack.isEmpty) {
          buttons.removeAt(i);
        }
        return false;
      }
    }
    */
    return true;
  }
}