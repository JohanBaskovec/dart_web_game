import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_soft_object_from_ground_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'take_from_ground_command.g.dart';

@JsonSerializable(anyMap: true)
class TakeFromGroundCommand extends ClientCommand {
  int itemId;

  TakeFromGroundCommand(this.itemId) : super(ClientCommandType.takeFromGround);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    final SolidObject player = client.session.player;
    if (itemId < 0) {
      print('Item id below 0\n');
      return;
    }
    if (itemId >= world.softObjects.length) {
      print('Item id is too high.\n');
      return;
    }
    final SoftObject item = world.getSoftObject(itemId);
    if (item == null) {
      print("Item doesn't exist.\n");
      return;
    }
    if (item.position == null) {
      print("Item has no position (it is in someone's inventory)\n");
      return;
    }
    if (!player.isAdjacentToPosition(item.position.toTilePosition())) {
      print('Item is too far.\n');
      return;
    }
    if (player.inventory.full) {
      print('Player inventory is full.\n');
      return;
    }
    final addCommand = AddToInventoryCommand(player.id, itemId);
    addCommand.execute(client.session, world);
    client.sendCommand(addCommand);

    final removeCommand = RemoveSoftObjectFromGroundCommand(itemId);
    removeCommand.execute(client.session, world);
    world.sendCommandToAllClients(removeCommand);
  }

  /// Creates a new [TakeFromGroundCommand] from a JSON object.
  static TakeFromGroundCommand fromJson(Map<dynamic, dynamic> json) =>
      _$TakeFromGroundCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TakeFromGroundCommandToJson(this);

  @override
  String toString() {
    return 'TakeFromGroundCommand{itemId: $itemId}';
  }
}
