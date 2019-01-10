import 'dart:convert';
import 'dart:html';

import 'package:dart_game/command/move_command.dart';
import 'package:dart_game/player.dart';
import 'package:dart_game/web_socket_client.dart';

class InputManager {
  final CanvasElement _canvas;
  final BodyElement _body;
  WebSocketClient webSocketClient;
  Player player;
  bool canvasActive = false;

  InputManager(this._body, this._canvas);

  void listen() {
    _body.onClick.listen((MouseEvent e) {
      if (e.target == _canvas) {
        canvasActive = true;
      }
    });
    _body.onKeyUp.listen((KeyboardEvent e) {
      if (canvasActive && player != null) {
        switch (e.key) {
          case 'd':
            final command = MoveCommand(1, 0, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
          case 'q':
            final command = MoveCommand(-1, 0, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
          case 's':
            final command = MoveCommand(0, 1, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
          case 'z':
            final command = MoveCommand(0, -1, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
        }
      }
    });
  }
}
