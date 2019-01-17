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
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_solid_object_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
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
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:yaml/yaml.dart';

class Server {
  HttpServer server;
  final List<Client> clients = [];
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
    final SolidObject player = client.session.player;
    final target = TilePosition(
        player.tilePosition.x + command.x, player.tilePosition.y + command.y);
    if (target.x < worldSize.x &&
        target.x >= 0 &&
        target.y < worldSize.y &&
        target.y >= 0 &&
        world.solidObjectColumns[target.x][target.y] == null) {
      moveSolidObject(player, target);
      final serverCommand =
          MoveSolidObjectCommand(player.id, player.tilePosition);
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
            addSolidObject(tree);
            final int nLeaves = randomGenerator.nextInt(6) + 1;
            for (int i = 0; i < nLeaves; i++) {
              final leaves = addSoftObject(SoftObjectType.leaves);
              tree.inventory.addItem(leaves);
            }

            final int nSnakes = randomGenerator.nextInt(6) + 1;
            for (int i = 0; i < nSnakes; i++) {
              final snake = addSoftObject(SoftObjectType.snake);
              tree.inventory.addItem(snake);
            }
          } else if (rand < 20) {
            final tree = makeAppleTree(x, y);
            addSolidObject(tree);
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
          }
        }
      }

      server.listen((HttpRequest request) async {
        try {
          if (world.freeSolidObjectIds.isEmpty) {
            // TODO: ErrorCommand
            return;
          }
          request.response.headers.add('Access-Control-Allow-Origin',
              '${config["frontend_host"]}:${config["frontend_port"]}');
          request.response.headers
              .add('Access-Control-Allow-Credentials', 'true');
          final WebSocket newPlayerWebSocket =
              await WebSocketTransformer.upgrade(request);

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
          if (newPlayer == null) {
            return;
          }
          addSolidObject(newPlayer);
          newPlayer.inventory.addItem(addSoftObject(SoftObjectType.hand));
          newPlayer.inventory.addItem(addSoftObject(SoftObjectType.axe));
          newPlayer.inventory.addItem(addSoftObject(SoftObjectType.log));
          newPlayer.inventory.addItem(addSoftObject(SoftObjectType.leaves));
          newPlayer.inventory.addItem(addSoftObject(SoftObjectType.leaves));

          // TODO: prevent synchro modification of clients,
          // because we may send wrong id to user otherwise
          final addNewPlayer = AddSolidObjectCommand(newPlayer);
          final loggedInCommand = LoggedInCommand(newPlayer.id, world);
          print('Client connected!');

          sendCommandToAllClients(addNewPlayer);
          final newClient = Client(Session(newPlayer), newPlayerWebSocket);
          clients.add(newClient);
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
            removeSolidObject(newPlayer);
            print('Client disconnected.');
            final removeCommand = RemoveSolidObjectCommand(newPlayer.id);
            sendCommandToAllClients(removeCommand);
            newPlayerWebSocket.close();
            clients.remove(newClient);
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
    final SolidObject target = world.solidObjects[command.targetId];
    final SoftObject item =
        world.softObjects[client.session.player.inventory.currentlyEquiped];
    useItemOnSolidObject(client, item, target);
  }

  void useItemOnSolidObject(
      Client client, SoftObject usedItem, SolidObject target) {
    final GatheringConfig config = gatheringConfigs[target.type];
    if (config == null ||
        usedItem.type != config.tool ||
        target.nGatherableItems == 0) {
      return;
    }

    target.nGatherableItems--;

    final gatheredItem = addSoftObject(config.gatherableItemsType);
    client.session.player.inventory.addItem(gatheredItem);
    final addObjectCommand = AddSoftObjectCommand(gatheredItem);
    client.sendCommand(addObjectCommand);
    final addToInventoryCommand = AddToInventoryCommand(gatheredItem.id);
    client.sendCommand(addToInventoryCommand);

    if (target.nGatherableItems == 0) {
      removeSolidObject(target);
      final removeCommand = RemoveSolidObjectCommand(target.id);
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
    final int playerInventoryLength = player.inventory.stacks.length;
    final removeFromInventoryCommand = RemoveFromInventoryCommand(
        player.id, List.filled(playerInventoryLength, 0));
    for (var type in recipe.keys) {
      final int quantity = recipe[type];
      for (int i = 0; i < playerInventoryLength; i++) {
        if (player.inventory.stacks[i].objectType == type) {
          if (player.inventory.stacks[i].length >= quantity) {
            removeFromInventoryCommand.nObjectsToRemoveFromEachStack[i] =
                quantity;
          } else {
            print('can\'t build object, not enough resources!');
            return;
          }
          break;
        }
      }
    }
    removeFromInventoryCommand.execute(world);
    final object = SolidObject(command.objectType, command.position);
    addSolidObject(object);
    sendCommandToAllClients(AddSolidObjectCommand(object));
    client.sendCommand(removeFromInventoryCommand);
  }

  void executeSendMessageCommand(Client newClient, SendMessageCommand command) {
    sendCommandToAllClients(AddMessageCommand(
        Message(newClient.session.player.name, command.message)));
  }

  void executeTakeFromInventoryCommand(
      Client newClient, TakeFromInventoryCommand command) {
    final SolidObject target = world.solidObjects[command.ownerId];
    final Stack stack = target.inventory.stacks[command.inventoryIndex];
    if (stack.isEmpty) {
      // concurrent access?
      return;
    }
    final SoftObject objectTaken = world.softObjects[stack.removeLast()];
    final List<int> nItemsToRemove =
        List.filled(target.inventory.stacks.length, 0);
    nItemsToRemove[command.inventoryIndex] = 1;
    if (stack.isEmpty) {
      target.inventory.stacks.removeAt(command.inventoryIndex);
    }
    newClient.session.player.inventory.addItem(objectTaken);

    final removeFromInventoryCommand =
        RemoveFromInventoryCommand(target.id, nItemsToRemove);
    newClient.sendCommand(removeFromInventoryCommand);

    final serverCommand = AddToInventoryCommand(objectTaken.id);
    newClient.sendCommand(serverCommand);
  }

  SoftObject addSoftObject(SoftObjectType type) {
    final object = SoftObject(type);
    if (world.freeSoftObjectIds.isEmpty) {
      object.id = world.softObjects.length;
      world.softObjects.add(object);
    } else {
      final int id = world.freeSoftObjectIds.removeLast();
      object.id = id;
      world.softObjects[id] = object;
    }
    return object;
  }

  void removeSoftObject(SoftObject object) {
    world.freeSoftObjectIds.add(object.id);
    world.softObjects.removeAt(object.id);
  }

  void addSolidObject(SolidObject object) {
    assert(
        world.freeSolidObjectIds.isNotEmpty,
        'this should never happen, there is exactly enough '
        'space in solidObject to hold every object.');
    final int id = world.freeSolidObjectIds.removeLast();
    object.id = id;
    final int objectAtPositionId =
        world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y];
    assert(objectAtPositionId == null);
    world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        object.id;
    assert(world.solidObjects[id] == null);
    world.solidObjects[id] = object;
  }

  void removeSolidObject(SolidObject object) {
    assert(world.solidObjectColumns[object.tilePosition.x]
            [object.tilePosition.y] !=
        null);
    assert(world.solidObjects[object.id] != null);
    world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        null;
    world.freeSolidObjectIds.add(object.id);
    world.solidObjects[object.id] = null;
  }

  void moveSolidObject(SolidObject object, TilePosition position) {
    world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        null;
    object.moveTo(position);
    world.solidObjectColumns[position.x][position.y] = object.id;
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
