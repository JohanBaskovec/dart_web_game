import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/tile.dart';
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
    final File worldFile = File('./data/world.json');
    if (worldFile.existsSync()) {
      final String worldJson = worldFile.readAsStringSync();
      world = ServerWorld.fromJson(jsonDecode(worldJson) as Map);
      world.gameServer = this;
    } else {
      world = ServerWorld.fromConstants();
      world.gameServer = this;
      fillWorldWithStuff();
      worldFile.writeAsStringSync(jsonEncode(world));
    }
    final File uuidFile = File('./data/uuid.txt');
    uuidFile.writeAsStringSync(random256BitsHex());
    startObjectsUpdate();

    httpServer = await HttpServer.bind(InternetAddress.anyIPv6, port);

    httpServer.listen((HttpRequest request) async {
      try {
        respondToRequest(request);
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

  Future<void> respondToRequest(HttpRequest request) async {
    final String shutdownUuid = request.uri.queryParameters['shutdown'];
    if (shutdownUuid != null) {
      final File uuidFile = File('./data/uuid.txt');
      final String uuid = uuidFile.readAsStringSync();
      if (uuid == shutdownUuid) {
        request.response.statusCode = 200;
        await request.response.close();
        await shutdown();
        return;
      } else {
        print('Invalid shutdown id provided: $shutdownUuid.\n');
      }
    }
    request.response.headers.add(
        'Access-Control-Allow-Origin', 'http://$frontendHost:$frontendPort');
    request.response.headers.add('Access-Control-Allow-Credentials', 'true');
    final WebSocket webSocket = await WebSocketTransformer.upgrade(request);
    final newClient = GameClient(null, webSocket, this);
    newClient.onLeave = () async {
      if (newClient.session != null) {
        newClient.session?.player?.client = null;
      }
      clients.remove(newClient);
      newClient.webSocket.close();
      print('Client disconnected.\n');
    };
    newClient.listen();
    clients.add(newClient);
  }

  void startObjectsUpdate() {
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      world.update();
    });
  }

  void fillWorldWithStuff() {
    for (int x = 0; x < world.solidObjectColumns.length; x++) {
      for (int y = 0; y < world.solidObjectColumns[x].length; y++) {
        final int rand = randomGenerator.nextInt(100);
        if (rand < 10) {
          final tree = makeTree(x, y);
          world.addSolidObject(tree);
          final int nLeaves = randomGenerator.nextInt(2) + 1;
          for (int i = 0; i < nLeaves; i++) {
            final leaves = world.addSoftObjectOfType(SoftObjectType.leaves);
            tree.inventory.addItem(leaves);
          }

          final int nSnakes = randomGenerator.nextInt(2);
          for (int i = 0; i < nSnakes; i++) {
            final snake = world.addSoftObjectOfType(SoftObjectType.snake);
            tree.inventory.addItem(snake);
          }
        } else if (rand < 20) {
          final tree = makeAppleTree(x, y);
          world.addSolidObject(tree);
          final int nApples = randomGenerator.nextInt(2) + 1;
          for (int i = 0; i < nApples; i++) {
            tree.inventory.addItem(world.addApple());
          }
        }
      }
    }
    for (int x = 0 ; x < worldSize.x ; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        final int rand = randomGenerator.nextInt(2);
        TileType type;
        if (rand == 0) {
          type = TileType.grass;
        } else {
          type = TileType.dirt;
        }
        world.addTileOfType(type, x, y);
      }
    }
  }

  Future<void> shutdown() async {
    print('Shutting down server...');
    print('Shutting down every websocket connections...');
    for (GameClient client in clients) {
      await client.close();
    }
    print('Shutting down HTTP connections and server...');
    await httpServer.close();

    print('Saving the world...');
    final File worldFile = File('./data/world.json');
    worldFile.writeAsStringSync(jsonEncode(world));
    print('Shutdown done. Exiting process.');
    exit(0);
  }

  String random256BitsHex() {
    return '${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}';
  }

  String random32BitsHex() {
    return randomGenerator.nextInt(1 << 32).toRadixString(16);
  }
}
