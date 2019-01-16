import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';

final Map<SolidObjectType, Map<SoftObjectType, int>> buildingRecipes = {
  SolidObjectType.woodenWall: {
    SoftObjectType.log: 5
  },
  SolidObjectType.campFire: {
    SoftObjectType.log: 1,
    SoftObjectType.leaves: 2
  }
};

bool playerCanBuild(SolidObjectType type, SolidObject player) {
  final Map<SoftObjectType, int> recipe = buildingRecipes[type];
  if (recipe == null) {
    return false;
  }
  final Map<SoftObjectType, int> required = Map.from(recipe);

  for (var type in recipe.keys) {
    for (int i = 0; i < player.inventory.stacks.length; i++) {
      if (player.inventory.stacks[i][0].type == type) {
        required[type] -= player.inventory.stacks[i].length;
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