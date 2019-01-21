import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/command/server/set_hunger_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_item_command.g.dart';

@JsonSerializable(anyMap: true)
class UseItemCommand extends ClientCommand {
  int itemId;

  UseItemCommand(this.itemId) : super(ClientCommandType.useItem);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    if (itemId < 0) {
      print('itemId below 0.\n');
      return;
    }
    if (itemId >= world.softObjects.length) {
      print('itemId too high.\n');
      return;
    }
    final SolidObject player = client.session.player;
    final SoftObject item = world.getSoftObject(itemId);
    if (item == null) {
      print("Item doen't exist.\n");
    }
    if (item.ownerId == null) {
      print('Item has no owner, that should never happen.\n');
      return;
    }
    final SolidObject owner = world.getSolidObject(item.ownerId);
    if (owner == null) {
      print("Item's owner is null, that should never happen.\n");
      return;
    }
    if (!owner.isAdjacentTo(player)) {
      print('Container of the item is too far.');
      return;
    }
    if (owner.inventory.private && owner.id != player.id) {
      print('Trying to use item of an inventory that is private.');
      return;
    }
    if (item.foodComponent != null) {
      final removeFromInventoryCommand =
          RemoveFromInventoryCommand(owner.id, [itemId]);
      removeFromInventoryCommand.execute(client.session, world);
      client.sendCommand(removeFromInventoryCommand);
      world.removeSoftObject(item);

      player.hungerComponent.hunger -= item.foodComponent.hungerReduction;
      if (player.hungerComponent.hunger < 0) {
        player.hungerComponent.hunger = 0;
      }
      client.sendCommand(SetHungerCommand(player.hungerComponent));
    }
  }

  /// Creates a new [UseItemCommand] from a JSON object.
  static UseItemCommand fromJson(Map<dynamic, dynamic> json) =>
      _$UseItemCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$UseItemCommandToJson(this);

  @override
  String toString() {
    return 'UseItemCommand{itemId: $itemId}';
  }
}
