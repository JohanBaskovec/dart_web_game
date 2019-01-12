import 'dart:async';
import 'dart:html';

import 'package:dart_game/client/input_manager.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/game_objects/world.dart';

class Game {
  void run() {
    final outputDiv = document.getElementById('output');
    outputDiv.innerHtml = '''<div>
  <canvas id="canvas"></canvas>
  </div>''';

    final CanvasElement canvas = document.getElementById('canvas');
    final renderer = Renderer(canvas);
    final world = World();

    Timer.periodic(Duration(milliseconds: (1000 / 60).floor()), (Timer timer) {
      renderer.render(world);
    });

    final inputManager = InputManager(document.body, canvas, world, renderer);
    inputManager.listen();

    final webSocketClient =
        WebSocketClient(WebSocket('ws:127.0.0.1:8083/ws'), world, inputManager, renderer);

    webSocketClient.connect();

    inputManager.webSocketClient = webSocketClient;
  }
}
