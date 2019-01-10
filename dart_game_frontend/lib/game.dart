import 'dart:async';
import 'dart:html';

import 'package:dart_game_common/size.dart';
import 'package:dart_game_common/world.dart';
import 'package:dart_game_frontend/input_manager.dart';
import 'package:dart_game_frontend/renderer.dart';
import 'package:dart_game_frontend/web_socket_client.dart';

class Game {
  void run() {
    final outputDiv = document.getElementById('output');
    outputDiv.innerHtml = '''<div>
  <canvas id="canvas"></canvas>
  </div>''';

    final CanvasElement canvas = document.getElementById('canvas');
    final renderer = Renderer(canvas);
    final world = World(Size(10, 10));

    Timer.periodic(Duration(milliseconds: (1000 / 60).floor()), (Timer timer) {
      renderer.render(world);
    });

    final inputManager = InputManager(document.body, canvas);
    inputManager.listen();

    final webSocketClient =
        WebSocketClient(WebSocket('ws:127.0.0.1:8083/ws'), world, inputManager);
    webSocketClient.connect();

    inputManager.webSocketClient = webSocketClient;
  }
}
