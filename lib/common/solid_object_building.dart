import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/receipes.dart';
import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';

bool playerCanBuild(SolidGameObjectType type, Player player) {
  final Map<SoftGameObjectType, int> receipe = solidReceipes[type];
  final Map<SoftGameObjectType, int> required = Map.from(receipe);

  for (var type in receipe.keys) {
    for (int i = 0; i < player.inventory.items.length; i++) {
      if (player.inventory.items[i][0].type == type) {
        required[type] -= player.inventory.items[i].length;
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