import 'package:dart_game/common/command/client/build_solid_object_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/client/move_command.dart';
import 'package:dart_game/common/command/client/send_message_command.dart';
import 'package:dart_game/common/command/client/set_equipped_item_client_command.dart';
import 'package:dart_game/common/command/client/take_from_inventory_command.dart';
import 'package:dart_game/common/command/client/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart';
import 'package:dart_game/server/world_manager.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_command.g.dart';

@JsonSerializable(anyMap: true)
class ClientCommand {
  ClientCommandType type;

  ClientCommand(this.type);

  void execute(GameClient client, WorldManager worldManager) {

  }

  /// Creates a new [ClientCommand] from a JSON object.
  static ClientCommand fromJson(Map<dynamic, dynamic> json) {
    final ClientCommandType type = _$enumDecode(_$ClientCommandTypeEnumMap, json['type']);
    switch (type) {
      case ClientCommandType.buildSolidObject:
        return BuildSolidObjectCommand.fromJson(json);
      case ClientCommandType.move:
        return MoveCommand.fromJson(json);
      case ClientCommandType.useObjectOnSolidObject:
        return UseObjectOnSolidObjectCommand.fromJson(json);
      case ClientCommandType.sendMessage:
        return SendMessageCommand.fromJson(json);
      case ClientCommandType.setEquippedItem:
        return SetEquippedItemClientCommand.fromJson(json);
      case ClientCommandType.takeFromInventory:
        return TakeFromInventoryCommand.fromJson(json);
      case ClientCommandType.addToInventory:
      case ClientCommandType.login:
      case ClientCommandType.unknown:
        break;
    }
    return null;
  }

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$ClientCommandToJson(this);
}