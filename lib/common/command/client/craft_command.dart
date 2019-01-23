import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'craft_command.g.dart';

@JsonSerializable(anyMap: true)
class CraftCommand extends ClientCommand {
  SoftObjectType objectType;
  List<int> itemIds;

  CraftCommand(this.objectType, this.itemIds) : super(ClientCommandType.craft);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    final SolidObject player = client.session.player;
    final Iterable<SoftObject> items = itemIds.map((itemId) => world.getSoftObject(itemId));
    if (!playerCanCraft(items, world, objectType, player)) {
      print("Player can't craft $objectType\n");
      return;
    }
    for (int itemId in itemIds) {
      if (!player.inventory.contains(itemId)) {
        print("Player inventory doesn't contain $itemId\n");
        return;
      }
    }

    final Map<SoftObjectType, int> recipe = craftingRecipes[objectType].requiredItems;
    final List<SoftObject> itemsToConsume = consumeItemsForCrafting(client, recipe, items, world);

    final removeFromInventoryCommand = RemoveFromInventoryCommand(player.id, []);
    double quality = 0;
    for (SoftObject item in itemsToConsume) {
      quality += item.quality;
      removeFromInventoryCommand.idsToRemove.add(item.id);
    }
    quality /= items.length;

    removeFromInventoryCommand.execute(client.session, world);
    client.sendCommand(removeFromInventoryCommand);

    final SoftObject craftedItem = world.addSoftObjectOfType(quality, objectType);
    final addSoftObjectCommand = AddSoftObjectCommand(craftedItem);
    client.sendCommand(addSoftObjectCommand);
    final addToInventoryCommand = AddToInventoryCommand(player.id, craftedItem.id);
    addToInventoryCommand.execute(client.session, world);
    client.sendCommand(addToInventoryCommand);
  }

  /// Creates a new [CraftCommand] from a JSON object.
  static CraftCommand fromJson(Map<dynamic, dynamic> json) => _$CraftCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$CraftCommandToJson(this);

  @override
  String toString() {
    return 'CraftCommand{objectType: $objectType}';
  }
}
