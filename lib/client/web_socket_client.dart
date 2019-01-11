import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/input_manager.dart';
import 'package:dart_game/common/command/add_player_command.dart';
import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/command/command_from_json.dart';
import 'package:dart_game/common/command/logged_in_command.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/remove_player_command.dart';
import 'package:dart_game/common/game_objects/world.dart';

class WebSocketClient {
  final WebSocket webSocket;
  final World _world;
  final InputManager _inputManager;

  WebSocketClient(this.webSocket, this._world, this._inputManager);

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
        case CommandType.login:
          break;
        case CommandType.unknown:
          break;
      }
    });
    webSocket.onOpen.listen((Event e) {});
  }

  void doMoveCommand(MoveCommand command) {
    _world.players[command.playerId].position.x += command.x;
    _world.players[command.playerId].position.y += command.y;
  }

  void doAddPlayerCommand(AddPlayerCommand command) {
    _world.players[command.player.id] = command.player;
  }

  void doRemovePlayerCommand(RemovePlayerCommand command) {
    _world.players[command.id] = null;
  }

  void doLoggedInCommand(LoggedInCommand command) {
    for (var player in command.players) {
      _world.players[player.id] = player;
    }
    _inputManager.player = command.player;
  }
}
