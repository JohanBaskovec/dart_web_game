import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/command/add_player_command.dart';
import 'package:dart_game/common/command/add_to_inventory_command.dart';
import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/command/command_from_json.dart';
import 'package:dart_game/common/command/logged_in_command.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/remove_player_command.dart';
import 'package:dart_game/common/command/remove_solid_object_command.dart';
import 'package:dart_game/common/command/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/axe.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/game_objects/tree.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:yaml/yaml.dart';

class Server {
  HttpServer server;
  final List<Client> clients = List(maxPlayers);
  Random randomGenerator = Random.secure();
  World world;

  void sendCommandToAllClients(Command command) {
    for (var client in clients) {
      if (client != null) {
        client.sendCommand(command);
      }
    }
  }

  void executeMoveCommand(MoveCommand command) {
    final targetX = world.players[command.playerId].tilePosition.x + command.x;
    final targetY = world.players[command.playerId].tilePosition.y + command.y;
    if (targetX < worldSize.x &&
        targetX >= 0 &&
        targetY < worldSize.y &&
        targetY >= 0 &&
        world.solidObjectColumns[targetX][targetY] == null) {
      world.players[command.playerId].move(command.x, command.y);
      sendCommandToAllClients(command);
    }
  }

  /// Run the application.
  Future<void> run() async {
    try {
      const configurationFileName = 'conf.dev.yaml';
      final configurationFile = File(configurationFileName);
      if (!configurationFile.existsSync()) {
        print('${configurationFile.path} does not exist!');
      }
      final String configurationFileContent =
          configurationFile.readAsStringSync();
      final YamlMap config = loadYaml(configurationFileContent) as YamlMap;

      server = await HttpServer.bind(InternetAddress.anyIPv6, 8083);
      world = World.fromConstants(randomGenerator);

      int nPlayers = 0;
      server.listen((HttpRequest request) async {
        try {
          if (nPlayers == maxPlayers) {
            // TODO: ErrorCommand
            return;
          }
          request.response.headers.add('Access-Control-Allow-Origin',
              '${config["frontend_host"]}:${config["frontend_port"]}');
          request.response.headers
              .add('Access-Control-Allow-Credentials', 'true');
          final WebSocket newPlayerWebSocket =
              await WebSocketTransformer.upgrade(request);
          int playerId;
          for (int i = 0; i < clients.length; i++) {
            if (clients[i] == null) {
              playerId = i;
              break;
            }
          }
          final newPlayer = Player(TilePosition(0, 0), 'admin', playerId);
          newPlayer.inventory.addItem(Axe());

          world.players[playerId] = newPlayer;
          nPlayers++;
          final newClient = Client(newPlayer, newPlayerWebSocket);
          // TODO: prevent synchro modification of clients,
          // because we may send wrong id to user otherwise
          final addNewPlayer = AddPlayerCommand(newPlayer);
          final loggedInCommand = LoggedInCommand(newPlayer, world);
          print('Client connected!');
          for (var i = 0; i < clients.length; i++) {
            if (clients[i] != null) {
              clients[i].webSocket.add(jsonEncode(addNewPlayer));
            }
          }
          clients[playerId] = newClient;
          final jsonCommand = jsonEncode(loggedInCommand.toJson());
          newPlayerWebSocket.add(jsonCommand);

          newPlayerWebSocket.listen((dynamic data) {
            final Command command = commandFromJson(data as String);
            switch (command.type) {
              case CommandType.move:
                executeMoveCommand(command as MoveCommand);
                break;
              case CommandType.useObjectOnSolidObject:
                executeUseObjectOnSolidObjectCommand(
                    command as UseObjectOnSolidObjectCommand);
                break;
              case CommandType.login:
              case CommandType.loggedIn:
              case CommandType.addPlayer: // should never happen
              case CommandType.removePlayer:
              case CommandType.unknown:
              case CommandType.addSolidObject:
              case CommandType.addSoftObject:
              case CommandType.removeSoftObject:
              case CommandType.removeFromInventory:
              case CommandType.addTile:
              case CommandType.removeTile:
                print('Error, received unknown command!');
            }
          }, onDone: () {
            print('Client disconnected.');
            final removeCommand = RemovePlayerCommand(playerId);
            sendCommandToAllClients(removeCommand);
            newPlayerWebSocket.close();
            clients[playerId] = null;
            world.players[playerId] = null;
          });
        } catch (e, s) {
          print(e);
          print(s);
        }
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  void executeUseObjectOnSolidObjectCommand(
      UseObjectOnSolidObjectCommand command) {
    final SolidGameObject target = world
        .solidObjectColumns[command.targetPosition.x][command.targetPosition.y];
    final Client client = clients[command.playerId];
    final SoftGameObject item =
        client.player.inventory.items[command.itemIndex];
    switch (target.type) {
      case SolidGameObjectType.tree:
        useItemOnTree(client, item, target as Tree);
        break;
      case SolidGameObjectType.player:
      case SolidGameObjectType.appleTree:
      case SolidGameObjectType.barkTree:
      case SolidGameObjectType.coconutTree:
      case SolidGameObjectType.leafTree:
      case SolidGameObjectType.ropeTree:
        throw Exception('Not implemented, should never happen.');
    }
  }

  void useItemOnTree(Client client, SoftGameObject item, Tree target) {
    if (item.type == SoftGameObjectType.axe) {
      final SoftGameObject itemCutFromTree = target.cut();
      client.player.inventory.addItem(itemCutFromTree);
      final addToInventoryCommand =
          AddToInventoryCommand(client.player.id, itemCutFromTree);
      client.webSocket.add(jsonEncode(addToInventoryCommand));

      if (target.dead) {
        world.solidObjectColumns[target.tilePosition.x][target.tilePosition.y] =
            null;
        final removeCommand = RemoveSolidObjectCommand(target.tilePosition);
        sendCommandToAllClients(removeCommand);
      }
    }
  }
}
