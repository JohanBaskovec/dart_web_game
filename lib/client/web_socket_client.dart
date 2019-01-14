import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/input_manager.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/add_entity_command.dart';
import 'package:dart_game/common/command/server/add_entity_with_rendering_command.dart';
import 'package:dart_game/common/command/server/add_grid_aligned_entity_command.dart';
import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_grid_aligned_entity_command.dart';
import 'package:dart_game/common/command/server/remove_entity_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/world_position.dart';

class WebSocketClient {
  final WebSocket webSocket;
  final World world;
  final InputManager inputManager;
  final Renderer renderer;
  final Chat chat;
  final PlayerInventoryMenu inventoryMenu;

  WebSocketClient(this.webSocket, this.world, this.inputManager, this.renderer,
      this.chat, this.inventoryMenu);

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final ServerCommand command =
          ServerCommand.fromJson(jsonDecode(e.data as String) as Map);
      switch (command.type) {
        case ServerCommandType.loggedIn:
          executeLoggedInCommand(command as LoggedInCommand);
          break;
        case ServerCommandType.addToInventory:
          executeAddToInventoryCommand(command as AddToInventoryCommand);
          break;
        case ServerCommandType.removeFromInventory:
          executeRemoveFromInventoryCommand(
              command as RemoveFromInventoryCommand);
          break;
        case ServerCommandType.removeEntity:
          executeRemoveEntityCommand(command as RemoveEntityCommand);
          break;
        case ServerCommandType.addEntity:
          executeAddEntityCommand(command as AddEntityCommand);
          break;
        case ServerCommandType.addMessage:
          executeAddMessageCommand(command as AddMessageCommand);
          break;
        case ServerCommandType.addEntityWithRendering:
          executeAddEntityWithRendering(
              command as AddEntityWithRenderingCommand);
          break;
        case ServerCommandType.addGridAlignedEntity:
          executeAddGridAlignedEntity(command as AddGridAlignedEntityCommand);
          break;
        case ServerCommandType.moveGridAlignedEntity:
          executeMoveGridAlignedEntity(command as MoveGridAlignedEntityCommand);
          break;
        case ServerCommandType.addRenderingComponent:
        case ServerCommandType.removeRenderingComponent:
        case ServerCommandType.unknown:
          print('Received a command that should '
              'never be received on the client of type ${command.type}.');
          break;
      }
    });
    webSocket.onOpen.listen((Event e) {});
  }

  void sendCommand(ClientCommand command) {
    webSocket.send(jsonEncode(command));
  }

  void executeLoggedInCommand(LoggedInCommand command) {
    world.solidObjectColumns = command.world.solidObjectColumns;
    world.tilesColumn = command.world.tilesColumn;
    world.publicInventories = command.world.publicInventories;
    world.privateInventories = command.world.privateInventories;
    world.worldPositions = command.world.worldPositions;
    world.gridPositions = command.world.gridPositions;
    world.tilesColumn = command.world.tilesColumn;
    world.renderingComponents = command.world.renderingComponents;
    world.entities = command.world.entities;
    world.boxes = command.world.boxes;
  }

  void executeRemoveEntityCommand(RemoveEntityCommand command) {
    world.removeEntity(command.entityId);
  }

  void executeAddToInventoryCommand(AddToInventoryCommand command) {
    /*
    inputManager.player.inventory.addItem(command.object);
    inventoryMenu.update();
    */
  }

  void executeAddEntityCommand(AddEntityCommand command) {
    world.entities[command.entityId] = command.entityId;
    /*
    world.solidObjectColumns[command.object.tilePosition.x]
        [command.object.tilePosition.y] = command.object;
        */
  }

  void executeRemoveFromInventoryCommand(RemoveFromInventoryCommand command) {
    /*
    for (int i = 0; i < command.nObjectsToRemoveFromEachStack.length; i++) {
      if (command.nObjectsToRemoveFromEachStack[i] != 0) {
        inputManager.player.inventory
            .removeFromStack(i, command.nObjectsToRemoveFromEachStack[i]);
      }
    }
    */
  }

  void executeAddMessageCommand(AddMessageCommand command) {
    chat.addMessage(command.message);
  }

  void executeAddEntityWithRendering(AddEntityWithRenderingCommand command) {
    // do nothing
  }

  void executeAddGridAlignedEntity(AddGridAlignedEntityCommand command) {
    world.addGridAlignedEntity(command.image, command.position);
  }

  void executeMoveGridAlignedEntity(MoveGridAlignedEntityCommand command) {
    world.gridPositions[command.entityId] = command.destination;
    world.worldPositions[command.entityId] = WorldPosition(
        (command.destination.x * tileSize).toDouble(),
        (command.destination.y * tileSize).toDouble());
  }
}
