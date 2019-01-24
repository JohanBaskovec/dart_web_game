import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/command/server/solid_object_summary.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/health/health_component.dart';
import 'package:dart_game/common/hunger_component.dart';
import 'package:dart_game/common/player_skills.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
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
    webSocket.add(jsonEncode(command.toJson()));
  }

  void sendCommands(Iterable<ServerCommand> commands) {
    commands.forEach(sendCommand);
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
        print('Time for request: $timeForRequest\n');
      } catch (e, s) {
        print(e);
        print(s);
      }
    }, onDone: () async {
      onLeave();
    });
  }

  Future<void> login(String username, String password, World world) async {
    assert(world != null);
    if (username == null || username.isEmpty) {
      print('Client tried to login with empty username!');
    }
    int playerId = gameServer.world.usernameToIdMap[username];
    if (playerId == null) {
      final SolidObject player = addNewPlayerAtRandomPosition(world);
      playerId = player.id;
      gameServer.world.usernameToIdMap[username] = playerId;
    }
    session = Session(playerId, username, world);
    // player is dead
    if (session.player == null) {
      final SolidObject player = addNewPlayerAtRandomPosition(world);
      session.playerId = player.id;
      gameServer.world.usernameToIdMap[username] = player.id;
    }
    assert(session != null);
    assert(session.player != null);
    assert(session.username != null);
    session.player.client = this;

    final List<SoftObject> softObjects = [];
    for (int i = 0; i < session.player.inventory.size; i++) {
      softObjects.add(world.getSoftObject(session.player.inventory[i]));
    }
    for (int x = 0 ; x < worldSize.x ; x++) {
      for (int y = 0 ; y < worldSize.y ; y++) {
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
    final LoggedInCommand loggedInCommand = LoggedInCommand(
        session,
        softObjects,
        solidObjectSummariesColumns,
        session.player,
        world.messages,
        world.tilesColumn);
    print('Client connected! $session.player\n');
    sendCommand(loggedInCommand);
  }

  SolidObject addNewPlayerAtRandomPosition(World world) {
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
      newPlayer.hungerComponent = HungerComponent(0, 1);
      final Map<SkillType, double> skills = {};
      for (var skillType in SkillType.values) {
        skills[skillType] = gameServer.randomGenerator.nextDouble();
      }

      newPlayer.playerSkills = PlayerSkills(skills);

      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.hand));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.axe));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.log));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.log));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.log));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.log));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.leaves));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.leaves));
      newPlayer.inventory.addItem(world.addSoftObjectOfType(
          gameServer.randomGenerator.nextDouble(), SoftObjectType.snake));
      newPlayer.healthComponent = HealthComponent.normalHumanBody(newPlayer.id);
      world.addSolidObject(newPlayer);
    }
    return newPlayer;
  }

  Future<void> close() async {
    await webSocket.close();
  }
}
