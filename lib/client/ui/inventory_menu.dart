import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/client/take_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';

class InventoryMenu {
  Box box = Box(0, 0, 0, 0);
  List<InventoryButton> buttons = [];
  SolidObject owner;
  SolidObject player;
  WebSocketClient webSocketClient;

  InventoryMenu(Box box, this.owner, this.player, this.webSocketClient) {
    moveAndResize(box);
  }
  void moveAndResize(Box box) {
    this.box = box;
  }

  void update() {
    final int widthPerStack = box.width ~/ 9;
    buttons = [];
    for (var i = 0; i < owner.inventory.items.length; i++) {
      final int left = box.left + i * widthPerStack + box.left;
      final newButton = InventoryButton(owner.inventory.items[i]);
      newButton.box = Box(left, box.top, widthPerStack, box.height);
      buttons.add(newButton);
    }
  }

  bool clickAt(CanvasPosition canvasPosition) {
    for (int i = 0 ; i < buttons.length ; i++) {
      if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        webSocketClient.sendCommand(TakeFromInventoryCommand(owner.id, i));
        return false;
      }
    }
    return true;
  }
}