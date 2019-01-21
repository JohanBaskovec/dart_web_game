import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile_position.dart';

final Map<SolidObjectType, Map<SoftObjectType, int>> buildingRecipes = {
  SolidObjectType.woodenWall: {SoftObjectType.log: 2},
  SolidObjectType.campFire: {SoftObjectType.log: 1, SoftObjectType.leaves: 2},
  SolidObjectType.box: {}
};

class CraftingConfiguration {
  SolidObjectType ovenType;
  Map<SoftObjectType, int> requiredItems;

  CraftingConfiguration(this.ovenType, this.requiredItems);
}

final Map<SoftObjectType, CraftingConfiguration> craftingRecipes = {
  SoftObjectType.cookedSnake:
      CraftingConfiguration(SolidObjectType.campFire, {SoftObjectType.snake: 1})
};

bool playerCanBuild(World world, SolidObjectType type, SolidObject player,
    TilePosition position) {
  if (position.distanceFrom(player.tilePosition) >= 2) {
    return false;
  }

  final Map<SoftObjectType, int> recipe = buildingRecipes[type];
  if (recipe == null) {
    return false;
  }
  final Map<SoftObjectType, int> required = Map.from(recipe);

  for (var type in recipe.keys) {
    for (int i = 0; i < player.inventory.items.length; i++) {
      final int itemId = player.inventory.items[i];
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
