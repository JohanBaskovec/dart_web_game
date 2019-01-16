import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/add_player_command.dart';
import 'package:dart_game/common/command/server/add_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_player_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_player_command.dart';
import 'package:dart_game/common/command/server/remove_solid_object_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_command.g.dart';

@JsonSerializable(anyMap: true)
class ServerCommand {
  ServerCommandType type;

  ServerCommand(this.type);

  /// Creates a new [ServerCommand] from a JSON object.
  static ServerCommand fromJson(Map<dynamic, dynamic> json) {
    final ServerCommandType type =
        _$enumDecode(_$ServerCommandTypeEnumMap, json['type']);
    switch (type) {
      case ServerCommandType.addPlayer:
        return AddPlayerCommand.fromJson(json);
      case ServerCommandType.addEntity:
        return AddEntityCommand.fromJson(json);
      case ServerCommandType.loggedIn:
        return LoggedInCommand.fromJson(json);
      case ServerCommandType.movePlayer:
        return MovePlayerCommand.fromJson(json);
      case ServerCommandType.addToInventory:
        return AddToInventoryCommand.fromJson(json);
      case ServerCommandType.removePlayer:
        return RemovePlayerCommand.fromJson(json);
      case ServerCommandType.removeEntity:
        return RemoveEntityCommand.fromJson(json);
      case ServerCommandType.removeFromInventory:
        return RemoveFromInventoryCommand.fromJson(json);
      case ServerCommandType.addMessage:
        return AddMessageCommand.fromJson(json);
      case ServerCommandType.addTile:
      case ServerCommandType.addSoftObject:
      case ServerCommandType.removeSoftObject:
      case ServerCommandType.removeTile:
        throw Exception('Trying to unserialize unimplemented'
            'command of type $type.');
        break;
      case ServerCommandType.unknown:
        throw Exception('Trying to unserialize command with type "unknown".');
        break;
    }

    throw Exception('Type is null in command ${json.toString()},'
        'this should never happen!');
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$ServerCommandToJson(this);
}
