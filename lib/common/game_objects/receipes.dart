import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';

final Map<EntityType, Map<EntityType, int>> solidReceipes = {
  EntityType.woodenWall: {
    EntityType.log: 5
  },
  EntityType.campFire: {
    EntityType.log: 1,
    EntityType.leaves: 2
  }
};