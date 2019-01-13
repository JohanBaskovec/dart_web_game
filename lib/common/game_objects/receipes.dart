import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';

final Map<SolidObjectType, Map<SoftObjectType, int>> solidReceipes = {
  SolidObjectType.woodenWall: {
    SoftObjectType.log: 5
  }
};