import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/session.dart';

class InventoryButton extends Button {
  int itemId;

  InventoryButton(this.itemId);
}

class PlayerInventoryMenu extends UiElement {
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
    box = Box(
        left: 20,
        top: screenHeight - height - marginBottom,
        width: width,
        height: height);
  }

  bool shiftLeftClick(CanvasPosition position) {
    if (uiController.craftingInventory.visible) {
      for (int i = 0; i < buttons.length; i++) {
        if (buttons[i].box.pointIsInBox(position.x, position.y) &&
            !uiController.craftingInventory.items.contains(buttons[i].itemId)) {
          uiController.craftingInventory.items.add(buttons[i].itemId);
          uiController.craftingInventory.update();
          print('Shift-left-click on item n°$i in player inventory');
          return true;
        }
      }
    } else {
      final activeInventoryWindow = uiController.activeInventoryWindow;
      if (activeInventoryWindow != null) {
        for (int i = 0; i < buttons.length; i++) {
          if (buttons[i].box.pointIsInBox(position.x, position.y)) {
            print('Shift-left-click on item n°$i in player inventory');
            /*
            webSocketClient.sendCommand(MoveToInventoryCommand(
                activeInventoryWindow.owner.id, buttons[i].itemId));
                */
            return true;
          }
        }
      }
    }
    return false;
  }

  int dragClick(CanvasPosition canvasPosition) {
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        print('Drag-click on item ${buttons[i].itemId} in player inventory');
        return buttons[i].itemId;
      }
    }
    return null;
  }

  void leftClick(CanvasPosition canvasPosition) {
    if (uiController.dragging) {
      final SoftObject item = uiController.maybeDraggedItem;
      /*
      if (session.player.inventory.contains(item.id)) {
        // TODO: move items inside the inventory
      } else {
        if (item.inInventory) {
          // TODO: move item from inventory to player's inventory
        } else {
          //webSocketClient.sendCommand(TakeFromGroundCommand(item.id));
        }
      }
      */
    }
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        print('Left-click on item n°$i in player inventory');
        //webSocketClient.sendCommand(SetEquippedItemClientCommand(i));
        break;
      }
    }
  }

  void rightClickAt(CanvasPosition position) {
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].box.pointIsInBox(position.x, position.y)) {
        print('Right-click on item n°$i in player inventory');
        //webSocketClient.sendCommand(UseItemCommand(buttons[i].itemId));
        break;
      }
    }
  }

  void update() {
    /*
    if (session == null) {
      return;
    }
    buttons = [];
    for (var i = 0; i < session.player.inventory.items.length; i++) {
      final int left = i * widthPerItem + box.left + paddingLeft;
      final newButton = InventoryButton(session.player.inventory.items[i]);
      newButton.box =
          Box(left: left, top:  box.top + paddingTop, width:  widthPerItem, height:  buttonHeight);
      buttons.add(newButton);
    }
    */
  }
}
