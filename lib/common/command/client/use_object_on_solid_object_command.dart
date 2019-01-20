import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/gathering.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_object_on_solid_object_command.g.dart';

bool playerCanGather(SolidObject player, World world, int targetId) {
  final SolidObject target = world.getSolidObject(targetId);
  if (!target.isAdjacentTo(player)) {
    return false;
  }
  final int equippedItemId = player.inventory.currentlyEquiped;
  final SoftObject item = world.getSoftObject(equippedItemId);

  final GatheringConfig config = gatheringConfigs[target.type];
  if (config == null ||
      item.type != config.tool ||
      target.nGatherableItems == 0 ||
      player.inventory.full) {
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
    final SolidObject player = client.session.player;
    if (!playerCanGather(player, world, targetId)) {
      print("Player can't gather.\n");
      return;
    }
    if (targetId < 0) {
      print('targetId below 0.\n');
      return;
    }
    if (targetId > world.solidObjects.length - 1) {
      print('targetId too high.\n');
      return;
    }
    final SolidObject target = world.getSolidObject(targetId);
    final GatheringConfig config = gatheringConfigs[target.type];

    assert(target.nGatherableItems > 0);
    target.nGatherableItems--;

    final gatheredItem = world.addSoftObjectOfType(config.gatherableItemsType);
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
