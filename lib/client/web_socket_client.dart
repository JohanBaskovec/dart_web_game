import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_solid_object_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_solid_object_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/command/server/set_equipped_item_server_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
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
        case ServerCommandType.setEquippedItem:
          executeSetEquippedCommand(command as SetEquippedItemServerCommand);
          break;
        case ServerCommandType.addSoftObject:
          executeAddSoftObjectCommand(command as AddSoftObjectCommand);
          break;
        case ServerCommandType.moveSolidObject:
          executeMoveSolidObjectCommand(command as MoveSolidObjectCommand);
          break;
        case ServerCommandType.unknown:
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

  void executeLoggedInCommand(LoggedInCommand command) {
    assert(command.playerId != null);
    _world.softObjects = command.world.softObjects;
    _world.solidObjects = command.world.solidObjects;
    _world.solidObjectColumns = command.world.solidObjectColumns;
    _world.tilesColumn = command.world.tilesColumn;
    session.player = _world.solidObjects[command.playerId];
    assert(session.player != null);
    session.player = _world.solidObjects[command.playerId];
  }

  void executeRemoveSolidObjectCommand(RemoveSolidObjectCommand command) {
    final SolidObject object = _world.solidObjects[command.id];
    _world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        null;
    _world.solidObjects[command.id] = null;
  }

  void executeAddToInventoryCommand(AddToInventoryCommand command) {
    assert(command.objectId != null);
    final SoftObject item = _world.softObjects[command.objectId];
    assert(item != null);
    session.player.inventory.addItem(item);
    inventoryMenu.update();
  }

  void executeAddSolidObjectCommand(AddSolidObjectCommand command) {
    _world.solidObjectColumns[command.object.tilePosition.x]
        [command.object.tilePosition.y] = command.object;
    _world.solidObjects[command.object.id] = command.object;
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
    assert(command.message != null);
    chat.addMessage(command.message);
  }

  void executeSetEquippedCommand(SetEquippedItemServerCommand command) {
    assert(command.itemId != null);
    session.player.inventory.currentlyEquiped = command.itemId;
  }

  void executeAddSoftObjectCommand(AddSoftObjectCommand command) {
    assert(command.object != null);
    assert(command.object.id != null);
    if (_world.softObjects.length <= command.object.id) {
      _world.softObjects.length = command.object.id + 1;
    }
    _world.softObjects[command.object.id] = command.object;
  }

  void executeMoveSolidObjectCommand(MoveSolidObjectCommand command) {
    assert(command.objectId != null);
    assert(command.position != null);
    assert(command.position.x != null);
    assert(command.position.y != null);
    _world.solidObjects[command.objectId]
        .move(command.position.x, command.position.y);
    _world.solidObjectColumns[command.position.x][command.position.y] =
        _world.solidObjects[command.objectId];
  }
}
