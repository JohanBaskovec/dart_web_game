import 'dart:async';
import 'dart:html';

import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/client/input_manager.dart' as input;
import 'package:dart_game/client/renderer.dart' as renderer;
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/session.dart';

class Game {
  void run() {
    currentSession = Session(null, null);
    world.init();
    renderer.init();

    Timer.periodic(Duration(milliseconds: (1000 / 60).floor()), (Timer timer) {
      renderer.render();
    });
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      world.update();
    });

    input.listen();

    webSocketClient = WebSocketClient(WebSocket('ws:127.0.0.1:8083/ws'));

    webSocketClient.connect();
  }
}
