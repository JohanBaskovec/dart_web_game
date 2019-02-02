import 'dart:html';
import 'dart:typed_data';

import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/login_client_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/session.dart';

class WebSocketClient {
  final WebSocket webSocket;

  WebSocketClient(this.webSocket) {
    webSocket.binaryType = 'arraybuffer';
  }

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final ByteBuffer data = e.data;

      final ServerCommand command =
          ServerCommand.fromByteData(data.asByteData());
      command.execute(currentSession, false);
    });
    webSocket.onOpen.listen((Event e) {
      // temporary until we make a login form
      final String search = window.location.search;
      if (search == '') {
        print('Missing username in query.');
        return;
      } else {
        final String username = search.substring(1);
        final loginCommand = LoginClientCommand(username, 'test-password');
        sendCommand(loginCommand);
      }
    });
  }

  void sendCommand(ClientCommand command) {
    webSocket.sendTypedData(command.toByteData());
  }
}

WebSocketClient webSocketClient;
