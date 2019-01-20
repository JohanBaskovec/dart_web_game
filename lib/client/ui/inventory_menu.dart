import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/client/take_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';

class InventoryMenu {
  Box box = Box(0, 0, 0, 0);
  List<InventoryButton> buttons = [];
  SolidObject owner;
  SolidObject player;
  WebSocketClient webSocketClient;
  int columns = 3;
  int rows = 3;
  bool active = true;
  ClientUiController uiController;

  InventoryMenu(Box box, this.owner, this.player, this.webSocketClient,
      this.uiController) {
    moveAndResize(box);
  }

  void moveAndResize(Box box) {
    this.box = box;
  }

  void update() {
    final int widthPerButton = box.width ~/ columns;
    final int heightPerButton = box.height ~/ rows;
    buttons = [];
    int row = 0;
    int column = 0;
    for (var i = 0; i < owner.inventory.items.length; i++) {
      final int left = box.left + column * widthPerButton;
      final int top = box.top + row * heightPerButton;
      final newButton = InventoryButton(owner.inventory.items[i]);
      newButton.box = Box(left, top, widthPerButton, heightPerButton);
      buttons.add(newButton);
      column++;
      if (column == columns) {
        column = 0;
        row++;
      }
    }
  }

  bool clickAt(CanvasPosition canvasPosition, InventoryMenu playerInventory,
      bool shift) {
    if (box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
      active = true;
      uiController.activeInventoryWindow = this;
    } else {
      active = false;
    }
    if (shift) {
      for (int i = 0; i < buttons.length; i++) {
        if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
          final int itemId = buttons[i].itemId;
          webSocketClient
              .sendCommand(TakeFromInventoryCommand(owner.id, itemId));
          return false;
        }
      }
    }
    return true;
  }
}
