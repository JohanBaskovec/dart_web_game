import 'dart:async';
import 'dart:html';

import 'package:dart_game/client/input_manager.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/client/windows_manager.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/client/ui/build_menu.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';

class Game {
  void run() {
    final outputDiv = document.getElementById('output');
    outputDiv.innerHtml = '''<div>
  <canvas id="canvas"></canvas>
  </div>''';

    final buildMenu = BuildMenu();
    final chat = Chat();
    final inventory = PlayerInventoryMenu();
    final CanvasElement canvas = document.getElementById('canvas');
    final windowsManager = WindowsManager();
    final renderer = Renderer(canvas, buildMenu, chat, inventory, windowsManager);
    final world = World();

    Timer.periodic(Duration(milliseconds: (1000 / 60).floor()), (Timer timer) {
      renderer.render(world);
    });


    final inputManager = InputManager(document.body, canvas, world, renderer,
        buildMenu, chat, inventory, windowsManager);
    inputManager.listen();

    final webSocketClient = WebSocketClient(WebSocket('ws:127.0.0.1:8083/ws'),
        world, inputManager, renderer, chat, inventory);

    webSocketClient.connect();

    chat.client = webSocketClient;

    inputManager.webSocketClient = webSocketClient;
  }
}
