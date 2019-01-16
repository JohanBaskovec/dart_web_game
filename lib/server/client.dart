import 'dart:convert';
import 'dart:io';

import 'package:dart_game/common/command/server/server_command.dart';

class Client {
  int playerId;
  WebSocket webSocket;

  Client(this.playerId, this.webSocket);

  void sendCommand(ServerCommand command) {
    webSocket.add(jsonEncode(command.toJson()));
  }
}
