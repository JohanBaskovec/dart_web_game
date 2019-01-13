import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';

final Map<SolidGameObjectType, Map<SoftGameObjectType, int>> solidReceipes = {
  SolidGameObjectType.woodenWall: {
    SoftGameObjectType.log: 5
  }
};