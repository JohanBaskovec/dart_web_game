import 'package:dart_game/common/game_objects/entity_type.dart';

final Map<EntityType, Map<EntityType, int>> solidReceipes = {
  EntityType.woodenWall: {
    EntityType.log: 5
  },
  EntityType.campFire: {
    EntityType.log: 1,
    EntityType.leaves: 2
  }
};