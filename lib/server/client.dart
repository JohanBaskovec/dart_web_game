import 'dart:io';

import 'package:dart_game/common/game_objects/player.dart';

class Client {
  Player player;
  WebSocket webSocket;

  Client(this.player, this.webSocket);
}
