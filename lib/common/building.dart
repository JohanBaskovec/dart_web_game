import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';

final Map<SolidObjectType, Map<SoftObjectType, int>> buildingRecipes = {
  SolidObjectType.woodenWall: {SoftObjectType.log: 2},
  SolidObjectType.campFire: {SoftObjectType.log: 1, SoftObjectType.leaves: 2},
  SolidObjectType.box: {}
};

class CraftingConfiguration {
  SolidObjectType workbench;
  Map<SoftObjectType, int> requiredItems;

  CraftingConfiguration(this.workbench, this.requiredItems);
}

bool playerCanBuild(World world, SolidObjectType type, SolidObject player,
    TilePosition position) {
  if (position.distanceFrom(player.tilePosition) >= 2) {
    return false;
  }

  final Map<SoftObjectType, int> recipe = buildingRecipes[type];
  if (recipe == null) {
    return false;
  }
  return _hasEnoughItems(player.inventory, recipe, world);
}

final Map<SoftObjectType, CraftingConfiguration> craftingRecipes = {
  SoftObjectType.cookedSnake:
      CraftingConfiguration(SolidObjectType.campFire, {SoftObjectType.snake: 1})
};

bool playerCanCraft(World world, SoftObjectType type, SolidObject player) {
  final CraftingConfiguration config = craftingRecipes[type];
  if (config == null) {
    print("Can't craft item $type because it has no config.\n");
    return false;
  }

  if (config.workbench != null) {
    SolidObject workBench;
    final Box box =
        Box(player.tilePosition.x - 1, player.tilePosition.y - 1, 2, 2);
    box.clamp(worldBox);
    for (int x = box.left; x <= box.right; x++) {
      for (int y = box.top; y <= box.bottom; y++) {
        final SolidObject objectAtPosition =
            world.getObjectAt(TilePosition(x, y));
        if (objectAtPosition != null &&
            objectAtPosition.type == config.workbench) {
          workBench = objectAtPosition;
        }
      }
    }
    if (workBench == null) {
      print("Can't craft item $type because there is no ${config.workbench}"
          ' next to the player.');
      return false;
    }
  }

  return _hasEnoughItems(player.inventory, config.requiredItems, world);
}

/// Remove items of recipes from inventory if there are enough of each
/// type, and synchronize the client
void removeItemsFromInventory(
    GameClient client, Map<SoftObjectType, int> recipe, World world) {
  final player = client.session.player;
  final int playerInventoryLength = player.inventory.items.length;
  final removeFromInventoryCommand = RemoveFromInventoryCommand(player.id, []);
  for (var type in recipe.keys) {
    final int quantityNeeded = recipe[type];
    int quantityOwned = 0;
    for (int i = 0; i < playerInventoryLength; i++) {
      final int itemId = player.inventory.items[i];
      final SoftObject item = world.getSoftObject(itemId);
      if (item.type == type) {
        quantityOwned++;
        removeFromInventoryCommand.idsToRemove.add(itemId);
        if (quantityOwned == quantityNeeded) {
          break;
        }
      }
    }
    if (quantityOwned < quantityNeeded) {
      print('can\'t build object, not enough resources!\n');
      return;
    }
  }
  removeFromInventoryCommand.execute(client.session, world, null);
  client.sendCommand(removeFromInventoryCommand);
}

bool _hasEnoughItems(
    Inventory inventory, Map<SoftObjectType, int> items, World world) {
  final Map<SoftObjectType, int> required = Map.from(items);

  for (var type in items.keys) {
    for (int i = 0; i < inventory.items.length; i++) {
      final int itemId = inventory.items[i];
      final SoftObject item = world.getSoftObject(itemId);
      if (item.type == type) {
        required[type] -= 1;
      }
    }
  }
  for (var type in required.keys) {
    if (required[type] > 0) {
      return false;
    }
  }
  return true;
}
