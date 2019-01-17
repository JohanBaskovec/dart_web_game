import 'dart:io';

import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/world_manager.dart';

class GameServer {
  HttpServer httpServer;
  int port;
  String frontendHost;
  int frontendPort;
  WorldManager worldManager;
  final List<GameClient> clients = [];

  GameServer.bind(
      this.port, this.frontendHost, this.frontendPort, this.worldManager) {
    worldManager.gameServer = this;
  }

  Future<void> listen() async {
    httpServer = await HttpServer.bind(InternetAddress.anyIPv6, port);

    httpServer.listen((HttpRequest request) async {
      try {
        if (worldManager.world.freeSolidObjectIds.isEmpty) {
          // TODO: ErrorCommand
          return;
        }
        request.response.headers.add('Access-Control-Allow-Origin', '');
        request.response.headers
            .add('Access-Control-Allow-Credentials', 'true');
        final WebSocket newPlayerWebSocket =
            await WebSocketTransformer.upgrade(request);

        addNewPlayer(newPlayerWebSocket);
      } catch (e, s) {
        print(e);
        print(s);
      }
    });
  }

  void sendCommandToAllClients(ServerCommand command) {
    for (var client in clients) {
      if (client != null) {
        client.sendCommand(command);
      }
    }
  }

  void addNewPlayer(WebSocket webSocket) {
    final SolidObject newPlayer = worldManager.addNewPlayerAtRandomPosition();
    if (newPlayer == null) {
      return;
    }

    final LoggedInCommand loggedInCommand =
        LoggedInCommand(newPlayer.id, worldManager.world);
    print('Client connected!');

    final newClient = GameClient(Session(newPlayer), webSocket, this);
    newClient.onLeave = () {
      worldManager.removeSolidObject(newPlayer);
      print('Client disconnected.');
      newClient.webSocket.close();
      clients.remove(newClient);
    };
    newClient.listen();
    clients.add(newClient);
    newClient.sendCommand(loggedInCommand);
  }
}
