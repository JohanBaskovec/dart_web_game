import 'dart:async';
import 'dart:html';

import 'package:dart_game/client/client_world.dart';
import 'package:dart_game/client/input_manager.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/session.dart';

class Game {
  void run() {
    final outputDiv = document.getElementById('output');
    outputDiv.innerHtml = '''<div>
  <canvas id="canvas"></canvas>
  </div>''';

    final world = ClientWorld();
    final CanvasElement canvas = document.getElementById('canvas');
    final session = Session(null, null);
    final uiController = ClientUiController(session, world);
    final renderer = Renderer(canvas, uiController, session);

    Timer.periodic(Duration(milliseconds: (1000 / 60).floor()), (Timer timer) {
      renderer.render(world);
    });
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      world.update();
    });

    final inputManager = InputManager(
        document.body, canvas, world, renderer, session, uiController);
    inputManager.listen();
    renderer.inputManager = inputManager;

    final webSocketClient = WebSocketClient(WebSocket('ws:127.0.0.1:8083/ws'),
        world, renderer, session, uiController);
    uiController.webSocketClient = webSocketClient;

    uiController.inventory.webSocketClient = webSocketClient;

    webSocketClient.connect();

    uiController.chat.client = webSocketClient;

    inputManager.webSocketClient = webSocketClient;
  }
}
