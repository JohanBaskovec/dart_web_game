import 'dart:convert';

import 'package:dart_game/common/command/add_player_command.dart';
import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/command/logged_in_command.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/remove_player_command.dart';

Command commandFromJson(String jsonString) {
  final Map jsonObject = jsonDecode(jsonString);
  Command command = Command.fromJson(jsonObject);
  switch (command.type) {
    case CommandType.move:
      command = MoveCommand.fromJson(jsonObject);
      break;
    case CommandType.addPlayer:
      command = AddPlayerCommand.fromJson(jsonObject);
      break;
    case CommandType.removePlayer:
      command = RemovePlayerCommand.fromJson(jsonObject);
      break;
    case CommandType.loggedIn:
      command = LoggedInCommand.fromJson(jsonObject);
      break;
    case CommandType.login:
      break;
    case CommandType.unknown:
      break;
  }
  return command;
}
