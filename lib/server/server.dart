import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/build_solid_object_command.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/client/move_command.dart';
import 'package:dart_game/common/command/client/send_message_command.dart';
import 'package:dart_game/common/command/client/set_equipped_item_client_command.dart';
import 'package:dart_game/common/command/client/take_from_inventory_command.dart';
import 'package:dart_game/common/command/client/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/add_player_command.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_player_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_player_command.dart';
import 'package:dart_game/common/command/server/remove_solid_object_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/set_equipped_item_server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/gathering.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/stack.dart';
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

  void executeMoveCommand(Client client, MoveCommand command) {
    final int playerId = client.session.id;
    final targetX = world.players[playerId].tilePosition.x + command.x;
    final targetY = world.players[playerId].tilePosition.y + command.y;
    if (targetX < worldSize.x &&
        targetX >= 0 &&
        targetY < worldSize.y &&
        targetY >= 0 &&
        world.solidObjectColumns[targetX][targetY] == null) {
      world.players[playerId].move(command.x, command.y);
      final serverCommand =
          MovePlayerCommand(playerId, world.players[playerId].tilePosition);
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
      world = World.fromConstants();

      for (int x = 0; x < world.solidObjectColumns.length; x++) {
        for (int y = 0; y < world.solidObjectColumns[x].length; y++) {
          final int rand = randomGenerator.nextInt(100);
          if (rand < 10) {
            final tree = makeTree(x, y);
            final int nLeaves = randomGenerator.nextInt(6) + 1;
            for (int i = 0; i < nLeaves; i++) {
              final leaves = SoftGameObject(SoftObjectType.leaves);
              addSoftObject(leaves);
              tree.inventory.addItem(leaves);
            }

            final int nSnakes = randomGenerator.nextInt(6) + 1;
            for (int i = 0; i < nSnakes; i++) {
              final snake = SoftGameObject(SoftObjectType.leaves);
              addSoftObject(snake);
              tree.inventory.addItem(snake);
            }
            world.solidObjectColumns[x][y] = tree;
          } else if (rand < 20) {
            final tree = makeAppleTree(x, y);
            final int nLogs = randomGenerator.nextInt(6) + 1;
            /*
            for (int i = 0 ; i < nLogs ; i++) {
              tree.inventory.addItem(SoftGameObject(SoftObjectType.fruitTreeLog));
            }
            final int nApples = randomGenerator.nextInt(6) + 1;
            for (int i = 0 ; i < nLogs ; i++) {
              tree.inventory.addItem(SoftGameObject(SoftObjectType.apple));
            }
            */
            world.solidObjectColumns[x][y] = tree;
          }
        }
      }

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
          final newPlayer = makePlayer(0, 0);
          final hand = SoftGameObject(SoftObjectType.hand);
          final axe = SoftGameObject(SoftObjectType.axe);
          addSoftObject(hand);
          addSoftObject(axe);
          newPlayer.inventory.addItem(hand);
          newPlayer.inventory.addItem(axe);

          world.players[playerId] = newPlayer;
          nPlayers++;
          final newClient =
              Client(Session(newPlayer, playerId), newPlayerWebSocket);
          // TODO: prevent synchro modification of clients,
          // because we may send wrong id to user otherwise
          final addNewPlayer = AddPlayerCommand(newPlayer);
          final loggedInCommand = LoggedInCommand(playerId, world);
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
            try {
              final ClientCommand command =
                  ClientCommand.fromJson(jsonDecode(data as String) as Map);
              switch (command.type) {
                case ClientCommandType.move:
                  executeMoveCommand(newClient, command as MoveCommand);
                  break;
                case ClientCommandType.useObjectOnSolidObject:
                  executeUseObjectOnSolidObjectCommand(
                      newClient, command as UseObjectOnSolidObjectCommand);
                  break;
                case ClientCommandType.buildSolidObject:
                  executeBuildSolidObjectCommand(
                      newClient, command as BuildSolidObjectCommand);
                  break;
                case ClientCommandType.sendMessage:
                  executeSendMessageCommand(
                      newClient, command as SendMessageCommand);
                  break;
                case ClientCommandType.takeFromInventory:
                  executeTakeFromInventoryCommand(
                      newClient, command as TakeFromInventoryCommand);
                  break;
                case ClientCommandType.setEquippedItem:
                  executeSetEquippedItemCommand(
                      newClient, command as SetEquippedItemClientCommand);
                  break;
                case ClientCommandType.login:
                case ClientCommandType.unknown:
                case ClientCommandType.addToInventory:
                  // unimplemented, should never happen
                  break;
              }
            } catch (e, s) {
              print(e);
              print(s);
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
      Client client, UseObjectOnSolidObjectCommand command) {
    final SolidObject target = world
        .solidObjectColumns[command.targetPosition.x][command.targetPosition.y];
    final SoftGameObject item =
        world.softObjects[client.session.player.inventory.currentlyEquiped];
    useItemOnSolidObject(client, item, target);
  }

  void useItemOnSolidObject(
      Client client, SoftGameObject usedItem, SolidObject target) {
    final GatheringConfig config = gatheringConfigs[target.type];
    if (config == null ||
        usedItem.type != config.tool ||
        target.nGatherableItems == 0) {
      return;
    }

    final SoftGameObject gatheredItem =
        SoftGameObject(config.gatherableItemsType);
    target.nGatherableItems--;

    addSoftObject(gatheredItem);
    client.session.player.inventory.addItem(gatheredItem);
    final addObjectCommand = AddSoftObjectCommand(gatheredItem);
    client.sendCommand(addObjectCommand);
    final addToInventoryCommand = AddToInventoryCommand(gatheredItem.id);
    client.sendCommand(addToInventoryCommand);

    if (target.nGatherableItems == 0) {
      world.solidObjectColumns[target.tilePosition.x][target.tilePosition.y] =
          null;
      final removeCommand = RemoveSolidObjectCommand(target.tilePosition);
      sendCommandToAllClients(removeCommand);
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

    final SolidObject player = client.session.player;

    final Map<SoftObjectType, int> recipe = buildingRecipes[command.objectType];
    if (!playerCanBuild(command.objectType, player)) {
      print('Tried to build an object but couldn\'t!');
      return;
    }
    final removeFromInventoryCommand = RemoveFromInventoryCommand([]);
    for (var type in recipe.keys) {
      for (int i = 0; i < player.inventory.stacks.length; i++) {
        if (player.inventory.stacks[i].objectType == type) {
          removeFromInventoryCommand.nObjectsToRemoveFromEachStack
              .add(recipe[type]);
          for (int k = 0; k < recipe[type]; k++) {
            player.inventory.removeFromStack(i);
          }
        } else {
          removeFromInventoryCommand.nObjectsToRemoveFromEachStack.add(0);
        }
      }
    }
    final object = SolidObject(command.objectType, command.position);
    world.solidObjectColumns[command.position.x][command.position.y] = object;
    sendCommandToAllClients(AddSolidObjectCommand(object));
    client.sendCommand(removeFromInventoryCommand);
  }

  void executeSendMessageCommand(Client newClient, SendMessageCommand command) {
    sendCommandToAllClients(AddMessageCommand(
        Message(newClient.session.player.name, command.message)));
  }

  void executeTakeFromInventoryCommand(
      Client newClient, TakeFromInventoryCommand command) {
    final SolidObject target = world.solidObjectColumns[command.tilePosition.x]
        [command.tilePosition.y];
    final Stack stack = target.inventory.stacks[command.index];
    if (stack.isEmpty) {
      // concurrent access?
      return;
    }
    final SoftGameObject objectTaken = world.softObjects[stack.removeLast()];
    newClient.session.player.inventory.addItem(objectTaken);
    final serverCommand = AddToInventoryCommand(objectTaken.id);
    newClient.sendCommand(serverCommand);
  }

  void addSoftObject(SoftGameObject object) {
    if (world.freeSoftObjectIds.isEmpty) {
      object.id = world.softObjects.length;
      world.softObjects.add(object);
    } else {
      final int id = world.freeSoftObjectIds.removeLast();
      object.id = id;
      world.softObjects[id] = object;
    }
  }

  void removeSoftObject(SoftGameObject object) {
    world.freeSoftObjectIds.add(object.id);
    world.softObjects.removeAt(object.id);
  }

  void executeSetEquippedItemCommand(
      Client newClient, SetEquippedItemClientCommand command) {
    final int itemId =
        newClient.session.player.inventory.stacks[command.inventoryIndex][0];
    newClient.session.player.inventory.currentlyEquiped = itemId;
    final serverCommand = SetEquippedItemServerCommand(itemId);
    newClient.sendCommand(serverCommand);
  }
}
