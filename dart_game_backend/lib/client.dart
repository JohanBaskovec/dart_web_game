import 'dart:io';

import 'package:dart_game_common/dart_game_common.dart';

class Client {
  Player player;
  WebSocket webSocket;

  Client(this.player, this.webSocket);
}
