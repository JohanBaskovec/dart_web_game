import 'dart:convert';
import 'dart:html';

import 'package:dart_game_common/dart_game_common.dart';
import 'package:dart_game_frontend/input_manager.dart';

class WebSocketClient {
  final WebSocket webSocket;
  final World _world;
  final InputManager _inputManager;

  WebSocketClient(this.webSocket, this._world, this._inputManager);

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final Map json = jsonDecode(e.data as String);
      if (json['type'] != null) {
        final CommandType type = commandTypeFromString(json['type'] as String);
        switch (type) {
          case CommandType.Move:
            final MoveCommand command = MoveCommand.fromJson(json);
            _world.players[command.playerId].position.x += command.x;
            _world.players[command.playerId].position.y += command.y;
            break;
          case CommandType.AddPlayer:
            final command = AddPlayerCommand.fromJson(json);
            // TODO: send the entire Player, without his email, password etc.
            final player = Player(command.name, command.id);
            if (_world.players.length < command.id + 1) {
              _world.players.length = command.id * 2;
            }
            _world.players[command.id] = player;
            break;
          case CommandType.Login:
            final command = LoginCommand.fromJson(json);
            final player = Player(command.name, command.id);
            if (_world.players.length < command.id + 1) {
              _world.players.length = (command.id + 1) * 2;
            }
            _world.players[command.id] = player;
            _inputManager.player = player;
            break;
          case CommandType.Unknown:
            break;
        }
      }
    });
    webSocket.onOpen.listen((Event e) {

    });
  }


}
