import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'take_from_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class TakeFromInventoryCommand extends ClientCommand {
  int ownerId;
  int inventoryIndex;

  TakeFromInventoryCommand(this.ownerId, this.inventoryIndex)
      : super(ClientCommandType.takeFromInventory);

  @override
  Future execute(GameClient client, World world) async {
    final Inventory userInventory = client.session.player.inventory;
    if (userInventory.full) {
      return;
    }
    final SolidObject target = world.getSolidObject(ownerId);
    if (inventoryIndex > target.inventory.size - 1) {
      print("Tried to take an item that doesn't exist from inventory! $this");
    }
    final int itemId = target.inventory.items[inventoryIndex];
    final removeFromInventoryCommand = RemoveFromInventoryCommand(target.id, [itemId]);
    removeFromInventoryCommand.execute(client.session, world);

    final addToInventoryCommand = AddToInventoryCommand(itemId);
    addToInventoryCommand.execute(client.session, world);

    client.sendCommand(removeFromInventoryCommand);
    client.sendCommand(addToInventoryCommand);

    print('Executed $this');
  }

  /// Creates a new [TakeFromInventoryCommand] from a JSON object.
  static TakeFromInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$TakeFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TakeFromInventoryCommandToJson(this);

  @override
  String toString() {
    return 'TakeFromInventoryCommand{ownerId: $ownerId, inventoryIndex: $inventoryIndex}';
  }
}
