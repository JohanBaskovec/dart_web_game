import 'dart:convert';
import 'dart:io';

import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/server/game_server.dart';

class GameClient {
  Session session;
  WebSocket webSocket;
  Function onLeave;
  GameServer gameServer;

  GameClient(this.session, this.webSocket, this.gameServer)
      : assert(session != null),
        assert(webSocket != null),
        assert(gameServer != null);

  void sendCommand(ServerCommand command) {
    webSocket.add(jsonEncode(command.toJson()));
  }

  void listen() {
    webSocket.listen((dynamic data) {
      try {
        final start = DateTime.now();
        final ClientCommand command =
            ClientCommand.fromJson(jsonDecode(data as String) as Map);
        command.execute(this, gameServer.world);
        final end = DateTime.now();
        final timeForRequest = end.difference(start);
        print('Time for request: $timeForRequest');
      } catch (e, s) {
        print(e);
        print(s);
      }
    }, onDone: () {
      onLeave();
    });
  }
}
