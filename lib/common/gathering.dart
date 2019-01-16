import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';

class GatheringConfig {
  SoftObjectType gatherableItemsType;
  SoftObjectType tool;

  GatheringConfig(this.gatherableItemsType, this.tool);
}

Map<SolidObjectType, GatheringConfig> gatheringConfigs = {
  SolidObjectType.tree: GatheringConfig(SoftObjectType.log, SoftObjectType.axe),
  SolidObjectType.appleTree:
      GatheringConfig(SoftObjectType.log, SoftObjectType.axe)
};
