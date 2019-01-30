import 'dart:io';
import 'dart:typed_data';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/send_world_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/server/game_server.dart';

class GameClient {
  Session session;
  WebSocket webSocket;
  Function onLeave;
  GameServer gameServer;
  String id;

  GameClient(this.session, this.webSocket, this.gameServer)
      : assert(webSocket != null),
        assert(gameServer != null);

  void sendCommand(ServerCommand command) {
    //webSocket.add(jsonEncode(command.toJson()));
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
    final command = ClientCommand.fromBuffer(bytes);
    command.execute(this, gameServer.world);
  }

  Future<void> login(String username, String password, World world) async {
    if (username == null || username.isEmpty) {
      print('Client tried to login with empty username!');
    }
    int playerId = gameServer.world.usernameToIdMap[username];
    Entity player;
    if (playerId == null) {
      player = addNewPlayerAtRandomPosition(world);
      playerId = player.id;
      gameServer.world.usernameToIdMap[username] = playerId;
    } else {
      player = world.entities[playerId];
    }
    // player is dead
    if (player == null) {
      player = addNewPlayerAtRandomPosition(world);
      playerId = player.id;
      gameServer.world.usernameToIdMap[username] = playerId;
    }
    session = Session(player, username);
    assert(session != null);
    assert(session.player != null);
    assert(session.username != null);
    final List<Entity> entities = List(world.entities.length);
    final List<List<int>> columns = List(worldSize.x);
    for (var x = 0; x < world.solidObjectColumns.length; x++) {
      columns[x] = List(worldSize.y);
      final List<int> rows = world.solidObjectColumns[x];
      for (var y = 0; y < rows.length; y++) {
        final Entity solidObject = world.entities[rows[y]];
        entities[rows[y]] = solidObject;
        if (solidObject != null) {
          columns[x][y] = rows[y];
        }
      }
    }
    /*
    session.player.client = this;

    final List<SoftObject> softObjects = [];
    for (int i = 0; i < session.player.inventory.size; i++) {
      softObjects.add(world.getSoftObject(session.player.inventory[i]));
    }
    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        final Tile tile = world.tilesColumn[x][y];
        for (int objectId in tile.itemsOnGround) {
          softObjects.add(world.getSoftObject(objectId));
        }
      }
    }
    final List<List<SolidObjectSummary>> solidObjectSummariesColumns =
        List(worldSize.x);
    for (int x = 0; x < worldSize.x; x++) {
      solidObjectSummariesColumns[x] = List(worldSize.y);
    }
    for (var x = 0; x < solidObjectSummariesColumns.length; x++) {
      final List<SolidObjectSummary> rows = solidObjectSummariesColumns[x];
      for (var y = 0; y < rows.length; y++) {
        final SolidObject solidObject = world.getObjectAt(TilePosition(x, y));
        if (solidObject != null) {
          rows[y] = SolidObjectSummary(solidObject.id, solidObject.type);
        }
      }
    }
    solidObjectSummariesColumns[session.player.tilePosition.x]
        [session.player.tilePosition.y] = null;
    */
    final SendWorldServerCommand sendWorldCommand =
        SendWorldServerCommand(session.player, entities, columns);
    print('Client connected! $session.player\n');
    sendCommand(sendWorldCommand);
  }

  Entity addNewPlayerAtRandomPosition(World world) {
    Entity newPlayer;
    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        if (world.solidObjectColumns[x][y] == null) {
          newPlayer = Entity();
          world.entities.add(newPlayer);
          final rendering = RenderingComponent(
              Box(x * tileSize, y * tileSize, tileSize, tileSize),
              newPlayer.id);
          world.renderingComponents.add(rendering);
          break;
        }
      }
      if (newPlayer != null) {
        break;
      }
    }
    if (newPlayer != null) {}
    return newPlayer;
  }

  Future<void> close() async {
    await webSocket.close();
  }
}
