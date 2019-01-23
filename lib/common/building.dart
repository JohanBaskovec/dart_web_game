import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/player_skills.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';

class BuildingConfiguration {
  SkillType skillRequired;
  Map<SoftObjectType, int> requiredItems;

  BuildingConfiguration(this.skillRequired, this.requiredItems);
}

final Map<SolidObjectType, BuildingConfiguration> buildingRecipes = {
  SolidObjectType.woodenWall:
      BuildingConfiguration(SkillType.carpentry, {SoftObjectType.log: 2}),
  SolidObjectType.campFire: BuildingConfiguration(
      SkillType.survival, {SoftObjectType.log: 1, SoftObjectType.leaves: 2}),
  SolidObjectType.box: BuildingConfiguration(null, {})
};

class CraftingConfiguration {
  SkillType skillRequired;
  SolidObjectType workbench;
  Map<SoftObjectType, int> requiredItems;

  CraftingConfiguration(this.workbench, this.requiredItems);
}

bool playerCanBuild(Iterable<SoftObject> items, World world, SolidObjectType type, SolidObject player,
    TilePosition position) {
  if (position.distanceFrom(player.tilePosition) >= 2) {
    return false;
  }

  final BuildingConfiguration recipe = buildingRecipes[type];
  if (recipe == null) {
    return false;
  }
  return _hasEnoughItems(items, recipe.requiredItems, world);
}

final Map<SoftObjectType, CraftingConfiguration> craftingRecipes = {
  SoftObjectType.cookedSnake:
      CraftingConfiguration(SolidObjectType.campFire, {SoftObjectType.snake: 1})
};

bool playerCanCraft(Iterable<SoftObject> items, World world, SoftObjectType type, SolidObject player) {
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

  return _hasEnoughItems(items, config.requiredItems, world);
}

/// Remove items of recipes from inventory if there are enough of each
/// type, and synchronize the client
List<SoftObject> consumeItemsForCrafting(GameClient client,
    Map<SoftObjectType, int> recipe, Iterable<SoftObject> items, World world) {
  final player = client.session.player;
  final List<SoftObject> itemsToConsume = [];
  for (var type in recipe.keys) {
    final int quantityNeeded = recipe[type];
    int quantityOwned = 0;
    for (SoftObject item in items) {
      if (item.type == type) {
        quantityOwned++;
        itemsToConsume.add(item);
        if (quantityOwned == quantityNeeded) {
          break;
        }
      }
    }
  }
  return itemsToConsume;
}

bool _hasEnoughItems(
    Iterable<SoftObject> items, Map<SoftObjectType, int> recipe, World world) {
  final Map<SoftObjectType, int> required = Map.from(recipe);

  for (var type in recipe.keys) {
    for (SoftObject item in items) {
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
