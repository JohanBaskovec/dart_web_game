import 'dart:io';

import 'package:dart_game/player.dart';

class Client {
  Player player;
  WebSocket webSocket;

  Client(this.player, this.webSocket);
}
