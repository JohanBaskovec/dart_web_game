import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/world_manager.dart';
import 'package:json_annotation/json_annotation.dart';

part 'take_from_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class TakeFromInventoryCommand extends ClientCommand {
  int ownerId;
  int inventoryIndex;

  TakeFromInventoryCommand(this.ownerId, this.inventoryIndex)
      : super(ClientCommandType.takeFromInventory);

  @override
  Future execute(GameClient client, WorldManager worldManager) async {
    final SolidObject target = worldManager.getSolidObject(ownerId);
    final int itemId = target.inventory.items[inventoryIndex];
    final SoftObject objectTaken = worldManager.getSoftObject(itemId);
    client.session.player.inventory.addItem(objectTaken);

    final removeFromInventoryCommand =
        RemoveFromInventoryCommand(target.id, [itemId]);
    client.sendCommand(removeFromInventoryCommand);

    final serverCommand = AddToInventoryCommand(itemId);
    client.sendCommand(serverCommand);
  }

  /// Creates a new [TakeFromInventoryCommand] from a JSON object.
  static TakeFromInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$TakeFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TakeFromInventoryCommandToJson(this);
}
