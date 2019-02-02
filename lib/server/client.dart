import 'dart:io';
import 'dart:typed_data';

import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/send_world_server_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/game_server.dart' as server;

class GameClient {
  Session session;
  WebSocket webSocket;
  Function onLeave;
  String id;

  GameClient(this.session, this.webSocket) : assert(webSocket != null);

  void sendCommand(ServerCommand command) {
    webSocket.add(command.toByteData().buffer.asUint8List());
  }

  void sendCommands(Iterable<ServerCommand> commands) {
    commands.forEach(sendCommand);
  }

  void listen() {
    webSocket.listen((dynamic data) {
      try {
        final start = DateTime.now();
        final Uint8List bytes = data;
        processData(ByteData.view(bytes.buffer));
        final end = DateTime.now();
        final timeForRequest = end.difference(start);
        print('Time for request: $timeForRequest\n');
      } catch (e, s) {
        print(e);
        print(s);
      }
    }, onDone: () async {
      onLeave();
    });
  }

  void processData(ByteData bytes) {
    final command = ClientCommand.fromByteData(bytes);
    command.execute(this);
  }

  Future<void> login(String username, String password) async {
    if (username == null || username.isEmpty) {
      print('Client tried to login with empty username!');
    }
    Entity player = server.usernameToPlayerMap[username];
    if (player == null) {
      player = addNewPlayerAtRandomPosition();
      server.usernameToPlayerMap[username] = player;
    }
    // player is dead
    if (player == null) {
      player = addNewPlayerAtRandomPosition();
      server.usernameToPlayerMap[username] = player;
    }
    session = Session(player, username);
    assert(session != null);
    assert(session.player != null);
    assert(session.username != null);

    // we only send the visible entities to the player on first login
    // (we then send other entities only when required,
    // such as items in inventories)
    final List<List<Entity>> entities = world.entities.objects;
    final sendWorldCommand = SendWorldServerCommand(
      playerArea: player.areaId,
      playerId: player.id,
      entitiesPerArea: entities,
    );
    print('Client connected!\n');
    sendCommand(sendWorldCommand);
  }

  Entity addNewPlayerAtRandomPosition() {
    Entity newPlayer;
    for (int x = 0; x < worldTileSize; x++) {
      for (int y = 0; y < worldTileSize; y++) {
        final Tile tile = world.getTileAt(TilePosition(x, y));
        if (tile.solidEntity == null) {
          newPlayer = Entity(
              type: EntityType.player,
              imageType: ImageType.player,
              x: x * tileSize,
              y: y * tileSize);
          world.entities.add(newPlayer);
          break;
        }
      }
      if (newPlayer != null) {
        break;
      }
    }
    if (newPlayer == null) {
      print("Couldn't find an empty space for new player!");
    }
    return newPlayer;
  }

  Future<void> close() async {
    await webSocket.close();
  }
}
