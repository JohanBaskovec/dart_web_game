import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/common/command/client/client_command.dart';
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
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';

class WebSocketClient {
  final WebSocket webSocket;
  final World _world;
  final Renderer renderer;
  final Chat chat;
  final PlayerInventoryMenu inventoryMenu;
  final Session session;

  WebSocketClient(this.webSocket, this._world, this.renderer, this.chat,
      this.inventoryMenu, this.session);

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final ServerCommand command =
          ServerCommand.fromJson(jsonDecode(e.data as String) as Map);
      switch (command.type) {
        case ServerCommandType.movePlayer:
          executeMoveCommand(command as MovePlayerCommand);
          break;
        case ServerCommandType.addPlayer:
          executeAddPlayerCommand(command as AddPlayerCommand);
          break;
        case ServerCommandType.removePlayer:
          executeRemovePlayerCommand(command as RemovePlayerCommand);
          break;
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
        case ServerCommandType.removeSolidObject:
          executeRemoveSolidObjectCommand(command as RemoveSolidObjectCommand);
          break;
        case ServerCommandType.addSolidObject:
          executeAddSolidObjectCommand(command as AddSolidObjectCommand);
          break;
        case ServerCommandType.addMessage:
          executeAddMessageCommand(command as AddMessageCommand);
          break;
        case ServerCommandType.unknown:
        case ServerCommandType.addSoftObject:
        case ServerCommandType.removeSoftObject:
        case ServerCommandType.addTile:
        case ServerCommandType.removeTile:
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

  void executeMoveCommand(MovePlayerCommand command) {
    _world.players[command.playerId].moveTo(command.targetPosition);
  }

  void executeAddPlayerCommand(AddPlayerCommand command) {
    _world.players.add(command.player);
  }

  void executeRemovePlayerCommand(RemovePlayerCommand command) {
    _world.players[command.id] = null;
  }

  void executeLoggedInCommand(LoggedInCommand command) {
    _world.solidObjectColumns = command.world.solidObjectColumns;
    _world.players = command.world.players;
    _world.tilesColumn = command.world.tilesColumn;
    session.player = _world.players[command.playerId];
    session.id = command.playerId;
  }

  void executeRemoveSolidObjectCommand(RemoveSolidObjectCommand command) {
    _world.solidObjectColumns[command.position.x][command.position.y] = null;
  }

  void executeAddToInventoryCommand(AddToInventoryCommand command) {
    session.player.inventory.addItem(command.object);
    inventoryMenu.update();
  }

  void executeAddSolidObjectCommand(AddSolidObjectCommand command) {
    _world.solidObjectColumns[command.object.tilePosition.x]
        [command.object.tilePosition.y] = command.object;
  }

  void executeRemoveFromInventoryCommand(RemoveFromInventoryCommand command) {
    for (int i = 0; i < command.nObjectsToRemoveFromEachStack.length; i++) {
      if (command.nObjectsToRemoveFromEachStack[i] != 0) {
        session.player.inventory
            .removeFromStack(i, command.nObjectsToRemoveFromEachStack[i]);
      }
    }
  }

  void executeAddMessageCommand(AddMessageCommand command) {
    chat.addMessage(command.message);
  }
}
