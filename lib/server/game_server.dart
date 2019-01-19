import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/solid_object_summary.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/hunger_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/server_world.dart';

class GameServer {
  Random randomGenerator = Random.secure();
  HttpServer httpServer;
  int port;
  String frontendHost;
  int frontendPort;
  ServerWorld world;
  final List<GameClient> clients = [];

  GameServer.bind(this.port, this.frontendHost, this.frontendPort);

  Future<void> listen() async {
    world = ServerWorld.fromConstants();
    world.gameServer = this;
    fillWorldWithStuff();
    startObjectsUpdate();

    httpServer = await HttpServer.bind(InternetAddress.anyIPv6, port);

    httpServer.listen((HttpRequest request) async {
      try {
        if (world.freeSolidObjectIds.isEmpty) {
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
    final SolidObject newPlayer = addNewPlayerAtRandomPosition();
    if (newPlayer == null) {
      return;
    }

    final newClient = GameClient(Session(newPlayer), webSocket, this);
    newClient.onLeave = () {
      world.removeSolidObject(newPlayer);
      print('Client disconnected.\n');
      newClient.webSocket.close();
      clients.remove(newClient);
    };
    newClient.listen();
    clients.add(newClient);

    final List<SoftObject> softObjects = List(newPlayer.inventory.items.length);
    for (int i = 0; i < newPlayer.inventory.size; i++) {
      softObjects[i] = world.getSoftObject(newPlayer.inventory[i]);
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
    final LoggedInCommand loggedInCommand = LoggedInCommand(newPlayer.id,
        newPlayer.inventory, softObjects, solidObjectSummariesColumns);
    print('Client connected! $newPlayer\n');
    newClient.sendCommand(loggedInCommand);
  }

  void startObjectsUpdate() {
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      final start = DateTime.now();
      for (int i = 0; i < world.solidObjects.length; i++) {
        final SolidObject object = world.solidObjects[i];

        if (object != null) {
          if (object.hungerComponent != null) {
            object.hungerComponent.update(world);
          }
          if (object.ageComponent != null) {
            object.ageComponent.update(world);
          }

          if (!object.alive) {
            world.removeSolidObject(object);
          }
        }
      }
      for (int i = 0; i < world.softObjects.length; i++) {
        final SoftObject object = world.softObjects[i];

        if (object != null) {
          if (object.ageComponent != null) {
            object.ageComponent.update(world);
          }

          if (!object.alive) {
            world.removeSoftObject(object);
          }
        }
      }
      final end = DateTime.now();
      final diff = end.difference(start);
      print('Updated all solid objects in $diff\n');
    });
  }

  SolidObject addNewPlayerAtRandomPosition() {
    SolidObject newPlayer;
    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        if (world.solidObjectColumns[x][y] == null) {
          newPlayer = makePlayer(x, y);
          break;
        }
      }
      if (newPlayer != null) {
        break;
      }
    }
    if (newPlayer != null) {
      newPlayer.hungerComponent = HungerComponent(0, 1) as HungerComponent;
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.hand));
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.axe));
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.log));
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.log));
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.log));
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.log));
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.log));
      newPlayer.inventory
          .addItem(world.addSoftObjectOfType(SoftObjectType.leaves));
      world.addSolidObject(newPlayer);
    }
    return newPlayer;
  }

  void fillWorldWithStuff() {
    for (int x = 0; x < world.solidObjectColumns.length; x++) {
      for (int y = 0; y < world.solidObjectColumns[x].length; y++) {
        final int rand = randomGenerator.nextInt(100);
        if (rand < 40) {
          final tree = makeTree(x, y);
          world.addSolidObject(tree);
          final int nLeaves = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLeaves; i++) {
            final leaves = world.addSoftObjectOfType(SoftObjectType.leaves);
            tree.inventory.addItem(leaves);
          }

          final int nSnakes = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nSnakes; i++) {
            final snake = world.addSoftObjectOfType(SoftObjectType.snake);
            tree.inventory.addItem(snake);
          }
        } else if (rand < 80) {
          final tree = makeAppleTree(x, y);
          world.addSolidObject(tree);
          final int nApples = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nApples; i++) {
            tree.inventory
                .addItem(world.addSoftObjectOfType(SoftObjectType.apple));
          }
        }
      }
    }
  }
}
