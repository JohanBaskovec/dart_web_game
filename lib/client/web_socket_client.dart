import 'dart:html';

import 'package:dart_game/client/input_manager.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/common/command/add_player_command.dart';
import 'package:dart_game/common/command/add_to_inventory_command.dart';
import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/command/command_from_json.dart';
import 'package:dart_game/common/command/logged_in_command.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/remove_player_command.dart';
import 'package:dart_game/common/command/remove_solid_object_command.dart';
import 'package:dart_game/common/game_objects/world.dart';

class WebSocketClient {
  final WebSocket webSocket;
  final World _world;
  final InputManager _inputManager;
  final Renderer renderer;

  WebSocketClient(this.webSocket, this._world, this._inputManager, this.renderer);

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final Command command = commandFromJson(e.data as String);
      switch (command.type) {
        case CommandType.move:
          doMoveCommand(command as MoveCommand);
          break;
        case CommandType.addPlayer:
          doAddPlayerCommand(command as AddPlayerCommand);
          break;
        case CommandType.removePlayer:
          doRemovePlayerCommand(command as RemovePlayerCommand);
          break;
        case CommandType.loggedIn:
          doLoggedInCommand(command as LoggedInCommand);
          break;
        case CommandType.addToInventory:
          executeAddToInventoryCommand(command as AddToInventoryCommand);
          break;
        case CommandType.removeSolidObject:
          executeRemoveSolidObjectCommand(command as RemoveSolidObjectCommand);
          break;
        case CommandType.useObjectOnSolidObject:
        case CommandType.login:
        case CommandType.unknown:
        case CommandType.addSolidObject:
        case CommandType.addSoftObject:
        case CommandType.removeSoftObject:
        case CommandType.removeFromInventory:
        case CommandType.addTile:
        case CommandType.removeTile:
          print('Received a command that should '
              'never be received on the client.');
          break;
      }
    });
    webSocket.onOpen.listen((Event e) {});
  }

  void doMoveCommand(MoveCommand command) {
    _world.players[command.playerId].move(command.x, command.y);
    if (command.playerId == _inputManager.player.id) {
      renderer.moveCameraToPlayerPosition(_inputManager.player.tilePosition);
    }
  }

  void doAddPlayerCommand(AddPlayerCommand command) {
    _world.players[command.player.id] = command.player;
  }

  void doRemovePlayerCommand(RemovePlayerCommand command) {
    _world.players[command.id] = null;
  }

  void doLoggedInCommand(LoggedInCommand command) {
    _world.solidObjectColumns = command.world.solidObjectColumns;
    _world.players = command.world.players;
    _world.tilesColumn = command.world.tilesColumn;
    _inputManager.player = _world.players[command.playerId];
  }

  void executeRemoveSolidObjectCommand(RemoveSolidObjectCommand command) {
    _world.solidObjectColumns[command.position.x][command.position.y] = null;
  }

  void executeAddToInventoryCommand(AddToInventoryCommand command) {
    _inputManager.player.inventory.addItem(command.object);
  }
}
