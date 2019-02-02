import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/server/client.dart';

Random randomGenerator = Random.secure();
HttpServer httpServer;
final List<GameClient> clients = [];
String _frontendHost;
int _frontendPort;
Map<String, int> usernameToIdMap = {};

Future<void> listen(int port, String frontendHost, int frontendPort) async {
  _frontendHost = frontendHost;
  _frontendPort = frontendPort;
  /*
  final File worldFile = File('./data/json');
    if (worldFile.existsSync()) {
      final String worldJson = worldFile.readAsStringSync();
      world = ServerWorld.fromJson(jsonDecode(worldJson) as Map);
      gameServer = this;
    } else {
      gameServer = this;
      worldFile.writeAsStringSync(jsonEncode(world));
    }
    */
  fillWorldWithStuff();
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
      'Access-Control-Allow-Origin', 'http://$_frontendHost:$_frontendPort');
  request.response.headers.add('Access-Control-Allow-Credentials', 'true');
  final WebSocket webSocket = await WebSocketTransformer.upgrade(request);
  final newClient = GameClient(null, webSocket);
  newClient.onLeave = () async {
    clients.remove(newClient);
    webSocket.close();
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
  for (int x = 0; x < worldSize; x++) {
    for (int y = 0; y < worldSize; y++) {
      final int rand = randomGenerator.nextInt(100);
      if (rand < 10) {
        addTree(randomGenerator.nextDouble(), x, y);
      }
    }
  }
  for (int x = 0; x < worldSize; x++) {
    for (int y = 0; y < worldSize; y++) {
      final int rand = randomGenerator.nextInt(2);
      if (rand == 0) {
        addTile(ImageType.grass, x, y);
      } else {
        addTile(ImageType.dirt, x, y);
      }
    }
  }
  for (int i = 0; i < 20; i++) {
    final int x = randomGenerator.nextInt(worldSizePx.x);
    final int y = randomGenerator.nextInt(worldSizePx.y);

    addEntityWithRendering(EntityType.food, ImageType.apple, x, y);
  }
}

Future<void> shutdown() async {
  /*
    print('Shutting down server...');
    print('Shutting down every websocket connections...');
    for (GameClient client in clients) {
      await client.close();
    }
    print('Shutting down HTTP connections and server...');
    await httpServer.close();

    print('Saving the ..');
    final File worldFile = File('./data/json');
    worldFile.writeAsStringSync(jsonEncode(world));
    print('Shutdown done. Exiting process.');
    */
  exit(0);
}

String random256BitsHex() {
  return '${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}${random32BitsHex()}';
}

String random32BitsHex() {
  return randomGenerator.nextInt(1 << 32).toRadixString(16);
}

Entity addEntity(EntityType type) {
  final entity = Entity(type: type);
  world.entities.add(entity);
  return entity;
}

Entity addTree(double nextDouble, int x, int y) {
  print('Adding tree.');
  return addGridAlignedEntity(
      EntityType.gatherable, ImageType.tree, x * tileSize, y * tileSize, 2);
}

Entity addEntityWithRendering(EntityType type, ImageType image, int x, int y) {
  final Entity entity = addEntity(type);
  addRenderingComponent(x, y, entity, false, image, 1);
  return entity;
}

Entity addTile(ImageType image, int x, int y) {
  return addGridAlignedEntity(
      EntityType.ground, image, x * tileSize, y * tileSize, 0);
}

Entity addGridAlignedEntity(
    EntityType type, ImageType image, int x, int y, int zIndex) {
  final Entity entity = addEntity(type);
  addGridAlignedRenderingComponent(x, y, entity, image, zIndex);
  print('Added $entity');
  return entity;
}

RenderingComponent addGridAlignedRenderingComponent(
    int x, int y, Entity entity, ImageType image, int zIndex) {
  return addRenderingComponent(x, y, entity, true, image, zIndex);
}

RenderingComponent addRenderingComponent(int x, int y, Entity entity,
    bool gridAligned, ImageType image, int zIndex) {
  final rendering = RenderingComponent.fromType(
      x: x, y: y, entityId: entity.id, imageType: image);
  world.addRenderingComponent(rendering);
  entity.renderingComponent = rendering;
  final Tile tile = world.getTileAt(rendering.tilePosition);

  if (gridAligned && zIndex == 2) {
    tile.solidEntity = entity;
  } else {
    tile.entitiesOnGround.add(entity);
  }
  return rendering;
}
