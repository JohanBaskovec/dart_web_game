import 'package:dart_game/common/game_objects/receipes.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';

bool playerCanBuild(SolidObjectType type, SolidObject player) {
  final Map<SoftObjectType, int> receipe = solidReceipes[type];
  final Map<SoftObjectType, int> required = Map.from(receipe);

  for (var type in receipe.keys) {
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