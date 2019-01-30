import 'dart:html';
import 'dart:typed_data';

import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/login_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class WebSocketClient {
  final WebSocket webSocket;
  final World _world;
  final Renderer renderer;
  final Session session;
  final UiController uiController;

  WebSocketClient(this.webSocket, this._world, this.renderer, this.session,
      this.uiController) {
    webSocket.binaryType = 'arraybuffer';
  }

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final ByteBuffer data = e.data;

      final ServerCommand command =
          ServerCommand.fromByteData(data.asByteData());
      command.execute(session, _world, uiController);
    });
    webSocket.onOpen.listen((Event e) {
      // temporary until we make a login form
      final String search = window.location.search;
      if (search == '') {
        print('Missing username in query.');
        return;
      } else {
        final String username = search.substring(1);
        final loginCommand = LoginCommand(username, 'test-password');
        sendCommand(loginCommand);
      }
    });
  }

  void sendCommand(ClientCommand command) {
    webSocket.sendTypedData(command.toByteData());
  }
}
