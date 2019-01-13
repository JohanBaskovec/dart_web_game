import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/command/client/build_solid_object_command.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/client/move_command.dart';
import 'package:dart_game/common/command/client/send_message_command.dart';
import 'package:dart_game/common/command/client/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/add_player_command.dart';
import 'package:dart_game/common/command/server/add_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_player_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_player_command.dart';
import 'package:dart_game/common/command/server/remove_solid_object_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/axe.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/receipes.dart';
import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/game_objects/tree.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/solid_object_building.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:yaml/yaml.dart';

class Server {
  HttpServer server;
  final List<Client> clients = List(maxPlayers);
  Random randomGenerator = Random.secure();
  World world;

  void sendCommandToAllClients(ServerCommand command) {
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
      final serverCommand = MovePlayerCommand(
          command.playerId, world.players[command.playerId].tilePosition);
      sendCommandToAllClients(serverCommand);
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

      server = await HttpServer.bind(
          InternetAddress.anyIPv6, config['backend_port'] as int);
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
          final loggedInCommand = LoggedInCommand(newPlayer.id, world);
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
            final ClientCommand command =
                ClientCommand.fromJson(jsonDecode(data as String) as Map);
            switch (command.type) {
              case ClientCommandType.move:
                executeMoveCommand(command as MoveCommand);
                break;
              case ClientCommandType.useObjectOnSolidObject:
                executeUseObjectOnSolidObjectCommand(
                    command as UseObjectOnSolidObjectCommand);
                break;
              case ClientCommandType.buildSolidObject:
                executeBuildSolidObjectCommand(
                    newClient, command as BuildSolidObjectCommand);
                break;
              case ClientCommandType.sendMessage:
                executeSendMessageCommand(
                    newClient, command as SendMessageCommand);
                break;
              case ClientCommandType.login:
              case ClientCommandType.unknown:
                // unimplemented, should never happen
                break;
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
        client.player.inventory.items[command.itemIndex][0];
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
      case SolidGameObjectType.woodenWall:
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

  void executeBuildSolidObjectCommand(
      Client client, BuildSolidObjectCommand command) {
    if (world.solidObjectColumns[command.position.x][command.position.y] !=
        null) {
      print(
          'Tried to build an object but one already exists at that position!');
      return;
    }

    final Player player = client.player;

    final Map<SoftGameObjectType, int> receipe =
        solidReceipes[command.objectType];
    if (!playerCanBuild(command.objectType, player)) {
      print('Tried to build an object but couldn\'t!');
      return;
    }
    final removeFromInventoryCommand =
        RemoveFromInventoryCommand(player.id, []);
    for (var type in receipe.keys) {
      for (int i = 0; i < player.inventory.items.length; i++) {
        // TODO: Stack class
        if (player.inventory.items[i][0].type == type) {
          removeFromInventoryCommand.nObjectsToRemoveFromEachStack
              .add(receipe[type]);
          for (int k = 0; k < receipe[type]; k++) {
            player.inventory.removeFromStack(i);
          }
        } else {
          removeFromInventoryCommand.nObjectsToRemoveFromEachStack.add(0);
        }
      }
    }
    switch (command.objectType) {
      case SolidGameObjectType.woodenWall:
        final object =
            SolidGameObject(SolidGameObjectType.woodenWall, command.position);
        world.solidObjectColumns[command.position.x][command.position.y] =
            object;
        sendCommandToAllClients(AddSolidObjectCommand(object));
        break;
      default:
        throw Exception('Not implemented!!');
        break;
    }
    client.sendCommand(removeFromInventoryCommand);
  }

  void executeSendMessageCommand(Client newClient, SendMessageCommand command) {
    sendCommandToAllClients(
        AddMessageCommand(Message(newClient.player.id, command.message)));
  }
}
