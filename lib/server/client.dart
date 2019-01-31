import 'dart:io';
import 'dart:typed_data';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/send_world_server_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile_position.dart';
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

    // we only send the visible entities to the player on first login
    // (we then send other entities only when required,
    // such as items in inventories)
    final entities = List<Entity>(world.entities.length);
    final renderingComponents =
        List<RenderingComponent>(world.renderingComponents.length);
    for (RenderingComponent renderingComponent in world.renderingComponents) {
      if (renderingComponent != null) {
        final Entity entity = renderingComponent.entity;
        entities[entity.id] = entity;
        renderingComponents[renderingComponent.id] = renderingComponent;
      }
    }
    final sendWorldCommand = SendWorldServerCommand(
        playerId: playerId,
        entities: entities,
        renderingComponents: renderingComponents);
    print('Client connected!\n');
    sendCommand(sendWorldCommand);
  }

  Entity addNewPlayerAtRandomPosition(World world) {
    Entity newPlayer;
    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        if (world.getSolidEntityAt(TilePosition(x, y)) == null) {
          newPlayer = Entity();
          world.entities.add(newPlayer);
          final rendering = RenderingComponent(
              box: Box(
                  left: x * tileSize,
                  top: y * tileSize,
                  width: tileSize,
                  height: tileSize),
              entityId: newPlayer.id,
              gridAligned: true,
              imageType: ImageType.player,
          zIndex: 1);
          world.renderingComponents.add(rendering);
          newPlayer.renderingComponentId = rendering.id;
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
