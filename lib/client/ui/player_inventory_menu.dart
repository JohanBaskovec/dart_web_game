import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/renderer.dart' as renderer;
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/ui.dart' as ui;
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/common/box.dart';

class InventoryButton extends Button {
  int itemId;

  InventoryButton(this.itemId);
}

class PlayerInventoryMenu extends UiElement {
  List<InventoryButton> buttons = [];
  static const double marginBottom = 0.1;
  static const double marginLeft = 0.1;
  static const double widthPerItem = 40;
  static const double buttonHeight = 40;
  static const double paddingTop = 10;
  static const double paddingBottom = 10;
  static const double paddingLeft = 0.1;
  static const double paddingRight = 10;
  static const double height = 0.2;
  static const double width = 0.5;

  PlayerInventoryMenu();

  @override
  void paint() {
    final ctx = renderer.ctxPlayerInventory;
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, renderer.canvasPlayerInventory.width,
        renderer.canvasPlayerInventory.height);
    final int heightPx = (height * renderer.canvas.height).toInt();
    final int marginBottomPx = (marginBottom * renderer.canvas.height).toInt();
    final int widthPx = (renderer.canvas.width * width).toInt();
    box = Box(
        left: (renderer.canvas.width * marginLeft).toInt(),
        top: renderer.canvas.height - heightPx - marginBottomPx,
        width: widthPx,
        height: heightPx);
    ctx.fillStyle = 'black';
    ctx
        .fillRect(box.left, box.top, box.width, box.height);
    /*
    for (var i = 0; i < buttons.length; i++) {
      final InventoryButton button = ui.inventory.buttons[i];
      final int itemId = button.itemId;
      final SoftObject item = world.getSoftObject(itemId);
      _ctx.drawImageScaled(softImages[item.type], button.box.left,
          button.box.top, button.box.width, button.box.height);
    }
    */
  }

  bool shiftLeftClick(CanvasPosition position) {
    if (ui.craftingInventory.visible) {
      for (int i = 0; i < buttons.length; i++) {
        if (buttons[i].box.pointIsInBox(position.x, position.y) &&
            !ui.craftingInventory.items.contains(buttons[i].itemId)) {
          ui.craftingInventory.items.add(buttons[i].itemId);
          ui.craftingInventory.update();
          print('Shift-left-click on item n°$i in player inventory');
          return true;
        }
      }
    } else {
      final activeInventoryWindow = ui.activeInventoryWindow;
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
    if (ui.dragging) {
      /*
      final SoftObject item = ui.maybeDraggedItem;
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
