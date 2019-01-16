import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/client/set_equipped_item_client_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/stack.dart';

class InventoryButton extends Button {
  Stack stack;

  InventoryButton(this.stack);
}

class PlayerInventoryMenu {
  Box box = Box(0, 0, 0, 0);
  List<InventoryButton> buttons = [];
  Session session;
  WebSocketClient webSocketClient;

  PlayerInventoryMenu(this.session, this.webSocketClient);

  void moveAndResize(Box box) {
    this.box = box;
  }

  bool clickAt(CanvasPosition canvasPosition) {
    if (session == null) {
      return true;
    }
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
        webSocketClient.sendCommand(SetEquippedItemClientCommand(i));
        return false;
      }
    }
    return true;
  }

  void update() {
    if (session == null) {
      return;
    }
    final double widthPerStack = box.width / 9;
    buttons = [];
    for (var i = 0; i < session.player.inventory.stacks.length; i++) {
      final double left = i * widthPerStack + box.left;
      final newButton =
          InventoryButton(session.player.inventory.stacks[i]);
      newButton.box = Box(left, box.top, widthPerStack, box.height);
      buttons.add(newButton);
    }
  }
}
