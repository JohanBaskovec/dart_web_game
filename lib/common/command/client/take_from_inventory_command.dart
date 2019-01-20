import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'take_from_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class TakeFromInventoryCommand extends ClientCommand {
  int ownerId;
  int itemId;

  TakeFromInventoryCommand(this.ownerId, this.itemId)
      : super(ClientCommandType.takeFromInventory);

  @override
  Future execute(GameClient client, World world) async {
    print('Executing $this\n');
    final Inventory userInventory = client.session.player.inventory;
    if (userInventory.full) {
      print('User inventory is full.\n');
      return;
    }
    if (ownerId < 0) {
      print('ownerId is less than 0\n');
      return;
    }
    if (ownerId >= world.solidObjects.length) {
      print('ownerId is too high.');
      return;
    }
    final SolidObject target = world.getSolidObject(ownerId);
    if (target == null) {
      print('Target is null.\n');
      return;
    }
    if (target.inventory.private) {
      print('Tried to take from a private inventory,'
          'this shouldn\'t be possible, cheater?\n');
      return;
    }
    if (!target.inventory.items.contains(itemId)) {
      print("Tried to take an item that isn't in inventory!\n");
      return;
    }
    if (!target.isAdjacentTo(client.session.player)) {
      print('Target is too far.\n');
      return;
    }
    final removeFromInventoryCommand =
        RemoveFromInventoryCommand(target.id, [itemId]);
    removeFromInventoryCommand.execute(client.session, world);

    final addToInventoryCommand =
        AddToInventoryCommand(client.session.player.id, itemId);
    addToInventoryCommand.execute(client.session, world);

    client.sendCommand(removeFromInventoryCommand);
    client.sendCommand(addToInventoryCommand);
  }

  /// Creates a new [TakeFromInventoryCommand] from a JSON object.
  static TakeFromInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$TakeFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TakeFromInventoryCommandToJson(this);

  @override
  String toString() {
    return 'TakeFromInventoryCommand{ownerId: $ownerId, inventoryIndex: $itemId}';
  }
}
