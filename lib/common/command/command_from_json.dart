import 'dart:convert';

import 'package:dart_game/common/command/add_player_command.dart';
import 'package:dart_game/common/command/add_solid_object_command.dart';
import 'package:dart_game/common/command/add_to_inventory_command.dart';
import 'package:dart_game/common/command/build_solid_object_command.dart';
import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/command/logged_in_command.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/remove_player_command.dart';
import 'package:dart_game/common/command/remove_solid_object_command.dart';
import 'package:dart_game/common/command/use_object_on_solid_object_command.dart';

// TODO: move to Command.fromJson
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
    case CommandType.useObjectOnSolidObject:
      command = UseObjectOnSolidObjectCommand.fromJson(jsonObject);
      break;
    case CommandType.removeSolidObject:
      command = RemoveSolidObjectCommand.fromJson(jsonObject);
      break;
    case CommandType.addToInventory:
      command = AddToInventoryCommand.fromJson(jsonObject);
      break;
    case CommandType.buildSolidObject:
      command = BuildSolidObjectCommand.fromJson(jsonObject);
      break;
    case CommandType.addSolidObject:
      command = AddSolidObjectCommand.fromJson(jsonObject);
      break;
    case CommandType.addSoftObject:
    case CommandType.removeSoftObject:
    case CommandType.removeFromInventory:
    case CommandType.login:
    case CommandType.addTile:
    case CommandType.removeTile:
      throw Exception('Command type not implemented!');
      break;
    case CommandType.unknown:
      break;
  }
  return command;
}
