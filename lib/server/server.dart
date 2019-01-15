import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/command/client/build_entity_command.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/client/move_command.dart';
import 'package:dart_game/common/command/client/send_message_command.dart';
import 'package:dart_game/common/command/client/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_rendering_and_collision_components_command.dart';
import 'package:dart_game/common/command/server/remove_entity_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/component/collision_component.dart';
import 'package:dart_game/common/component/inventory_component.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';
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
    final Entity player = client.player;
    final collisionComponent =
        world.collisionComponents[player.collisionComponentId];
    final target = WorldPosition(collisionComponent.box.left + command.x,
        collisionComponent.box.top + command.y);
    // TODO: improve performances
    for (int i = 0; i < world.collisionComponents.length; i++) {
      final CollisionComponent collisionComponent =
          world.collisionComponents[i];
      if (collisionComponent != null &&
          collisionComponent.box.top == target.y &&
          collisionComponent.box.left == target.x) {
        return;
      }
    }
    if (target.x < worldSizePx.x &&
        target.x >= 0 &&
        target.y < worldSizePx.y &&
        target.y >= 0) {
      final serverCommand = MoveRenderingAndCollisionComponentsCommand(
          player.renderingComponentId, player.collisionComponentId, target);
      world.executeMoveGridAlignedEntity(serverCommand);
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
          final Entity newPlayer =
              world.addGridAlignedEntity(EntityType.player, TilePosition(0, 0));
          final playerInventory = InventoryComponent();
          playerInventory.addItem(world.createAndAddEntity(EntityType.hand));
          playerInventory.addItem(world.createAndAddEntity(EntityType.axe));

          nPlayers++;
          final newClient = Client(newPlayer, newPlayerWebSocket);
          // TODO: prevent synchro modification of clients,
          // because we may send wrong id to user otherwise
          // TODO: should be add entity
          //final addNewPlayer = AddPlayerCommand(newPlayer);
          final loggedInCommand = LoggedInCommand(
              newPlayer.id,
              world.renderingComponents,
              world.collisionComponents,
              world.entities);
          print('Client connected!');
          for (var i = 0; i < clients.length; i++) {
            if (clients[i] != null) {
              //clients[i].webSocket.add(jsonEncode(addNewPlayer));
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
                case ClientCommandType.useObjectOnEntity:
                  executeUseObjectOnEntityCommand(
                      newClient, command as UseObjectOnEntityCommand);
                  break;
                case ClientCommandType.buildEntity:
                  executeBuildEntityCommand(
                      newClient, command as BuildEntityCommand);
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
            } catch (e, s) {
              print(e);
              print(s);
            }
          }, onDone: () {
            print('Client disconnected.');
            final removeCommand = RemoveEntityCommand(newPlayer);
            sendCommandToAllClients(removeCommand);
            newPlayerWebSocket.close();
            clients[playerId] = null;
            world.removeEntity(newPlayer);
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

  void executeUseObjectOnEntityCommand(
      Client client, UseObjectOnEntityCommand command) {
    /*
    final Entity target = world
        .solidObjectColumns[command.targetPosition.x][command.targetPosition.y];
    final Entity item =
        client.player.inventory.stacks[command.itemIndex][0];
    useItemOnEntity(client, item, target);
    */
  }

  void useItemOnEntity(Client client, int itemId, int targetId) {
    /*
    final Entity itemReceivedFromAction = target.useItem(item);
    if (itemReceivedFromAction != null) {
      client.player.inventory.addItem(itemReceivedFromAction);
      final addToInventoryCommand =
          AddToInventoryCommand(client.player.id, itemReceivedFromAction);
      client.sendCommand(addToInventoryCommand);

      if (!target.alive) {
        world.solidObjectColumns[target.tilePosition.x][target.tilePosition.y] =
            null;
        final removeCommand = RemoveEntityCommand(target.tilePosition);
        sendCommandToAllClients(removeCommand);
      }
    }
    */
  }

  void executeBuildEntityCommand(Client client, BuildEntityCommand command) {
    /*
    if (world.solidObjectColumns[command.position.x][command.position.y] !=
        null) {
      print(
          'Tried to build an object but one already exists at that position!');
      return;
    }

    final Player player = client.player;

    final Map<EntityType, int> receipe = solidReceipes[command.entityType];
    if (!playerCanBuild(command.entityType, player)) {
      print('Tried to build an object but couldn\'t!');
      return;
    }
    final removeFromInventoryCommand =
        RemoveFromInventoryCommand(player.id, []);
    for (var type in receipe.keys) {
      for (int i = 0; i < player.inventory.stacks.length; i++) {
        if (player.inventory.stacks[i][0].type == type) {
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
    switch (command.entityType) {
      case EntityType.woodenWall:
        final object =
            Entity(EntityType.woodenWall, command.position);
        world.solidObjectColumns[command.position.x][command.position.y] =
            object;
        sendCommandToAllClients(AddEntityCommand(object));
        break;
      default:
        throw Exception('Not implemented!!');
        break;
    }
    client.sendCommand(removeFromInventoryCommand);
    */
  }

  void executeSendMessageCommand(Client newClient, SendMessageCommand command) {
    sendCommandToAllClients(
        AddMessageCommand(Message(newClient.player.id, command.message)));
  }
}
