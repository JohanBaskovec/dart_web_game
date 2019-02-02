import 'package:dart_game/common/game_objects/soft_object.dart';

enum SkillType {
  cooking,
  survival,
  woodcutting,
  carpentry,
  axeWielding,
  unarmedCombat,
  forging,
  woodWeaponCrafting,
  steelWeaponCrafting,
  strength,
  damageResistance,
  dexterity
}

Map<SoftObjectType, SkillType> weaponTypeToSkillMap = {
  SoftObjectType.axe: SkillType.axeWielding,
  SoftObjectType.hand: SkillType.unarmedCombat
};

class PlayerSkills {
  Map<SkillType, double> skills = {};

  PlayerSkills(this.skills);
}
