import 'dart:convert';
import 'dart:io';

import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/command/server/server_command.dart';

class Client {
  Session session;
  WebSocket webSocket;

  Client(this.session, this.webSocket);

  void sendCommand(ServerCommand command) {
    webSocket.add(jsonEncode(command.toJson()));
  }
}
