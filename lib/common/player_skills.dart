import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_skills.g.dart';

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

@JsonSerializable(anyMap: true)
class PlayerSkills {
  Map<SkillType, double> skills = {};

  PlayerSkills(this.skills);



  /// Creates a new [PlayerSkills] from a JSON object.
  static PlayerSkills fromJson(Map<dynamic, dynamic> json) =>
      _$PlayerSkillsFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$PlayerSkillsToJson(this);
}
