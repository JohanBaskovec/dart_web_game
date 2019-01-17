import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/gathering.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_object_on_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class UseObjectOnSolidObjectCommand extends ClientCommand {
  int targetId;

  UseObjectOnSolidObjectCommand(
      this.targetId)
      : super(ClientCommandType.useObjectOnSolidObject);


  @override
  void execute(GameClient client, GameServer gameServer) {
    final SolidObject target = gameServer.worldManager.world.solidObjects[targetId];
    final SoftObject item =
    gameServer.worldManager.world.softObjects[client.session.player.inventory.currentlyEquiped];

    final GatheringConfig config = gatheringConfigs[target.type];
    if (config == null ||
        item.type != config.tool ||
        target.nGatherableItems == 0) {
      return;
    }

    target.nGatherableItems--;

    final gatheredItem = gameServer.worldManager.addSoftObject(config.gatherableItemsType);
    client.session.player.inventory.addItem(gatheredItem);
    final addObjectCommand = AddSoftObjectCommand(gatheredItem);
    client.sendCommand(addObjectCommand);
    final addToInventoryCommand = AddToInventoryCommand(gatheredItem.id);
    client.sendCommand(addToInventoryCommand);

    if (target.nGatherableItems == 0) {
      gameServer.worldManager.removeSolidObject(target);
    }
  }

  /// Creates a new [UseObjectOnSolidObjectCommand] from a JSON object.
  static UseObjectOnSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$UseObjectOnSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$UseObjectOnSolidObjectCommandToJson(this);
}
