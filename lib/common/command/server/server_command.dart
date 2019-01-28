import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/drop_soft_object_server_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_soft_object_command.dart';
import 'package:dart_game/common/command/server/move_solid_object_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_soft_object_from_ground_command.dart';
import 'package:dart_game/common/command/server/remove_solid_object_command.dart';
import 'package:dart_game/common/command/server/send_inventory_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/command/server/set_equipped_item_server_command.dart';
import 'package:dart_game/common/command/server/set_hunger_command.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_command.g.dart';

@JsonSerializable(anyMap: true)
class ServerCommand {
  ServerCommandType type;

  ServerCommand(this.type);

  void execute(Session session, World world, [UiController uiController]) {
    // must have an implementation because abstract class can't be serialized
    throw Exception('Implement me!');
  }

  /// Creates a new [ServerCommand] from a JSON object.
  static ServerCommand fromJson(Map<dynamic, dynamic> json) {
    final ServerCommandType type =
        _$enumDecode(_$ServerCommandTypeEnumMap, json['type']);
    switch (type) {
      case ServerCommandType.addSolidObject:
        return AddSolidObjectCommand.fromJson(json);
      case ServerCommandType.loggedIn:
        return LoggedInCommand.fromJson(json);
      case ServerCommandType.addToInventory:
        return AddToInventoryCommand.fromJson(json);
      case ServerCommandType.removeSolidObject:
        return RemoveSolidObjectCommand.fromJson(json);
      case ServerCommandType.moveSolidObject:
        return MoveSolidObjectCommand.fromJson(json);
      case ServerCommandType.removeFromInventory:
        return RemoveFromInventoryCommand.fromJson(json);
      case ServerCommandType.addMessage:
        return AddMessageCommand.fromJson(json);
      case ServerCommandType.setEquippedItem:
        return SetEquippedItemServerCommand.fromJson(json);
      case ServerCommandType.addSoftObject:
        return AddSoftObjectCommand.fromJson(json);
      case ServerCommandType.sendInventory:
        return SendInventoryCommand.fromJson(json);
      case ServerCommandType.setHunger:
        return SetHungerCommand.fromJson(json);
      case ServerCommandType.moveSoftObject:
        return MoveSoftObjectCommand.fromJson(json);
      case ServerCommandType.dropSoftObject:
        return DropSoftObjectServerCommand.fromJson(json);
      case ServerCommandType.removeSoftObjectFromGround:
        return RemoveSoftObjectFromGroundCommand.fromJson(json);
      case ServerCommandType.setAge:
      case ServerCommandType.addTile:
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
