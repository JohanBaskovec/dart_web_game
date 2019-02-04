import 'dart:html';
import 'dart:typed_data';

import 'package:dart_game/client/ui/client_ui_controller.dart' as ui;
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/login_client_command.dart';
import 'package:dart_game/common/command/server/move_entity_server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/command/server_to_client/server_to_client_command.dart';
import 'package:dart_game/common/session.dart';

class WebSocketClient {
  final WebSocket webSocket;

  WebSocketClient(this.webSocket) {
    webSocket.binaryType = 'arraybuffer';
  }

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final ByteBuffer data = e.data;

      final ServerToClientCommand command =
          ServerToClientCommand.fromByteData(data.asByteData());
      command.execute(currentSession);
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
