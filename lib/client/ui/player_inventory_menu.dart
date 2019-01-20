import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/client/move_to_inventory_command.dart';
import 'package:dart_game/common/command/client/set_equipped_item_client_command.dart';
import 'package:dart_game/common/session.dart';

class InventoryButton extends Button {
  int itemId;

  InventoryButton(this.itemId);
}

class PlayerInventoryMenu {
  Box box = Box(0, 0, 0, 0);
  List<InventoryButton> buttons = [];
  Session session;
  WebSocketClient webSocketClient;
  ClientUiController uiController;
  static const int marginBottom = 10;
  static const int widthPerItem = 40;
  static const int buttonHeight = 40;
  static const int paddingTop = 10;
  static const int paddingBottom = 10;
  static const int paddingLeft = 10;
  static const int paddingRight = 10;
  static const int height = 40 + paddingTop + paddingBottom;
  static const int width = 9 * 40 + paddingLeft + paddingRight;

  PlayerInventoryMenu(this.session, this.webSocketClient, [this.uiController]);

  void reinitialize(int screenWidth, int screenHeight) {
    box = Box(20, screenHeight - height - marginBottom, width, height);
  }

  bool clickAt(CanvasPosition canvasPosition, bool shift) {
    if (session == null) {
      return true;
    }
    final activeInventoryWindow = uiController.activeInventoryWindow;
    if (shift && activeInventoryWindow != null) {
      for (int i = 0; i < buttons.length; i++) {
        if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
          print('Shift-left-click on item n°$i in player inventory');
          webSocketClient.sendCommand(MoveToInventoryCommand(
              activeInventoryWindow.owner.id, buttons[i].itemId));
          break;
        }
      }
    } else if (!shift) {
      for (int i = 0; i < buttons.length; i++) {
        if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
          print('Left-click on item n°$i in player inventory');
          webSocketClient.sendCommand(SetEquippedItemClientCommand(i));
          break;
        }
      }
    }
    if (box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
      return true;
    }
    return false;
  }

  void update() {
    if (session == null) {
      return;
    }
    buttons = [];
    for (var i = 0; i < session.player.inventory.items.length; i++) {
      final int left = i * widthPerItem + box.left + paddingLeft;
      final newButton = InventoryButton(session.player.inventory.items[i]);
      newButton.box =
          Box(left, box.top + paddingTop, widthPerItem, buttonHeight);
      buttons.add(newButton);
    }
  }
}
