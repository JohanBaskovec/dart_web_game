import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/input.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';

class Chat {
  bool enabled = true;
  Box box = Box(left: 0, top: 0, width: 0, height: 0);
  Button sendButton = Button();
  Input input = Input();
  WebSocketClient client;

  Chat();

  void moveAndResize(Box box) {
    final int sendButtonWidth = box.width ~/ 10;
    sendButton.box = Box(
        left: box.right - sendButtonWidth,
        top: box.bottom - 40,
        width: sendButtonWidth,
        height: 40);
    input.box = Box(
        left: box.left,
        top: (box.bottom - box.height / 10).toInt(),
        width: box.width,
        height: box.height ~/ 10);
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
