import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_message_command.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/gathering.dart';
import 'package:dart_game/common/health/body_part.dart';
import 'package:dart_game/common/health/body_part_status.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/player_skills.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_object_on_solid_object_command.g.dart';

bool playerCanGather(SolidObject player, World world, int targetId) {
  final SolidObject target = world.getSolidObject(targetId);
  if (target == null) {
    print('playerCanGather: target is false.\n');
    return false;
  }
  if (!target.isAdjacentTo(player)) {
    print("playerCanGather: target isn't adjacent to user.\n");
    return false;
  }
  final int equippedItemId = player.inventory.currentlyEquiped;
  final SoftObject item = world.getSoftObject(equippedItemId);

  final GatheringConfig config = gatheringConfigs[target.type];
  if (config == null) {
    print("Object of type ${target.type} can't be mined.\n");
    return false;
  }
  if (item.type != config.tool) {
    print('Required item ${config.tool} not equipped.\n');
    return false;
  }
  if (target.nGatherableItems == 0) {
    print('No gatherable items left.\n');
    return false;
  }
  if (player.inventory.full) {
    print("Player's inventory is full.\n");
    return false;
  }
  return true;
}

@JsonSerializable(anyMap: true)
class UseObjectOnSolidObjectCommand extends ClientCommand {
  int targetId;

  UseObjectOnSolidObjectCommand(this.targetId)
      : super(ClientCommandType.useObjectOnSolidObject);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    if (targetId < 0) {
      print('targetId below 0.\n');
      return;
    }
    if (targetId > world.solidObjects.length - 1) {
      print('targetId too high.\n');
      return;
    }
    final SolidObject target = world.getSolidObject(targetId);
    if (target.type == SolidObjectType.player) {
      attackPlayer(client, target, world);
    } else {
      if (!playerCanGather(client.session.player, world, targetId)) {
        print("Player can't gather.\n");
        return;
      }

      gatherResources(client, target, world);
    }
  }

  void attackPlayer(GameClient client, SolidObject target, World world) {
    final SolidObject player = client.session.player;
    final int equipedItemId = player.inventory.currentlyEquiped;
    final SoftObject equipedItem = world.getSoftObject(equipedItemId);
    final SkillType skillType = weaponTypeToSkillMap[equipedItem.type];
    if (skillType == null) {
      print("Can't attack $target with item $equipedItem!");
    }
    final double weaponSkill = player.playerSkills.skills[skillType];
    final double strength = player.playerSkills.skills[SkillType.strength];
    final damage = (weaponSkill * strength * 100).floor();
    final healthComponent = target.healthComponent;
    final bodyParts = healthComponent.allBodyParts;
    final int r = client.gameServer.randomGenerator.nextInt(bodyParts.length);
    final BodyPart bodyPart = bodyParts[r];
    target.healthComponent.attackBodyPart(bodyPart, damage);
    final List<AddMessageCommand> addMessageCommands = [];
    addMessageCommands.add(AddMessageCommand(Message(
        'Combat', 'Attacked ${bodyPart.name}, causing $damage damages.')));
    if (bodyPart.status == BodyPartStatus.severed) {
      addMessageCommands.add(AddMessageCommand(
          Message('Combat', '${bodyPart.name} has been severed!')));
    }
    if (!target.healthComponent.alive) {
      addMessageCommands
          .add(AddMessageCommand(Message('Combat', '${target.name} is dead!')));
      target.alive = false;
    }
    for (ServerCommand command in addMessageCommands) {
      command.execute(client.session, world);
    }
    client.sendCommands(addMessageCommands);
  }

  void gatherResources(GameClient client, SolidObject target, World world) {
    final SolidObject player = client.session.player;
    final GatheringConfig config = gatheringConfigs[target.type];
    assert(target.nGatherableItems > 0);
    target.nGatherableItems--;

    final woodCuttingSkill = player.playerSkills.skills[SkillType.woodcutting];
    final double quality = woodCuttingSkill * target.quality;
    final gatheredItem =
        world.addSoftObjectOfType(quality, config.gatherableItemsType);
    final addObjectCommand = AddSoftObjectCommand(gatheredItem);
    addObjectCommand.execute(client.session, world);
    final addToInventoryCommand =
        AddToInventoryCommand(player.id, gatheredItem.id);
    addToInventoryCommand.execute(client.session, world);

    client.sendCommand(addObjectCommand);
    client.sendCommand(addToInventoryCommand);

    if (target.nGatherableItems == 0) {
      world.removeSolidObjectAndSynchronizeAllClients(target);
    }
  }

  /// Creates a new [UseObjectOnSolidObjectCommand] from a JSON object.
  static UseObjectOnSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$UseObjectOnSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$UseObjectOnSolidObjectCommandToJson(this);

  @override
  String toString() {
    return 'UseObjectOnSolidObjectCommand{targetId: $targetId}';
  }
}
