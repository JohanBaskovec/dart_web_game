import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/send_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_to_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveToInventoryCommand extends ClientCommand {
  int targetId;
  int itemId;

  MoveToInventoryCommand(this.targetId, this.itemId)
      : super(ClientCommandType.moveToInventory);

  @override
  Future execute(GameClient client, World world) async {
    print('Executing $this.\n');
    if (targetId < 0) {
      print('targetId below 0.\n');
      return;
    }
    if (targetId > world.solidObjects.length - 1) {
      print('targetId too high.\n');
      return;
    }
    if (itemId < 0) {
      print('itemId below 0.\n');
      return;
    }
    if (itemId > world.softObjects.length - 1) {
      print('itemId too high.\n');
      return;
    }
    final SolidObject player = client.session.player;
    if (!player.inventory.contains(itemId)) {
      print("Player's inventory doesn't contain itemId.\n");
      return;
    }
    final SolidObject target = world.getSolidObject(targetId);
    if (target.inventory == null) {
      print("Target doesn't have an inventory!");
      return;
    }
    if (!target.isAdjacentTo(client.session.player)) {
      print('Target is not adjacent to the player.\n');
      return;
    }
    if (target.inventory.full) {
      print('Target inventory is full.');
      return;
    }
    final addToInventoryCommand = AddToInventoryCommand(targetId, itemId);
    addToInventoryCommand.execute(client.session, world);
    final removeFromInventoryCommand = RemoveFromInventoryCommand(player.id, [itemId]);
    removeFromInventoryCommand.execute(client.session, world);
    client.sendCommand(addToInventoryCommand);
    client.sendCommand(removeFromInventoryCommand);
  }

  /// Creates a new [MoveToInventoryCommand] from a JSON object.
  static MoveToInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveToInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveToInventoryCommandToJson(this);

  @override
  String toString() {
    return 'MoveToInventoryCommand{targetId: $targetId, itemId: $itemId}';
  }
}
