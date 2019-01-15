import 'dart:convert';
import 'dart:io';

import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/entity.dart';

class Client {
  Entity player;
  WebSocket webSocket;

  Client(this.player, this.webSocket);

  void sendCommand(ServerCommand command) {
    webSocket.add(jsonEncode(command.toJson()));
  }
}
