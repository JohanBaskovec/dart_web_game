import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/input.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';

class Chat {
  bool enabled = true;
  Box box = Box(0, 0, 0, 0);
  Button sendButton = Button();
  Input input = Input();
  WebSocketClient client;

  Chat();

  void moveAndResize(Box box) {
    final int sendButtonWidth = box.width ~/ 10;
    sendButton.box =
        Box(box.right - sendButtonWidth, box.bottom - 40, sendButtonWidth, 40);
    input.box = Box(box.left, (box.bottom - box.height / 10).toInt(), box.width,
        box.height ~/ 10);
    this.box = box;
  }

  bool clickAt(CanvasPosition canvasPosition) {
    if (input.box.pointIsInBox(canvasPosition.x, canvasPosition.y)) {
      input.active = true;
      return false;
    }
    return true;
  }

  void type(String key) {
    if (key == 'Enter') {
      if (client != null) {
        //client.sendCommand(SendMessageCommand(input.content));
        input.content = '';
      }
    } else if (key == 'Backspace') {
      input.content = input.content.substring(0, input.content.length);
    } else {
      input.type(key);
    }
  }
}
