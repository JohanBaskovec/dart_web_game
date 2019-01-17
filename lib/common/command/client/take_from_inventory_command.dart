import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/stack.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart';
import 'package:json_annotation/json_annotation.dart';

part 'take_from_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class TakeFromInventoryCommand extends ClientCommand {
  int ownerId;
  int inventoryIndex;

  TakeFromInventoryCommand(this.ownerId, this.inventoryIndex)
      : super(ClientCommandType.takeFromInventory);

  @override
  Future execute(GameClient client, GameServer gameServer) async {
    final SolidObject target =
        gameServer.worldManager.world.solidObjects[ownerId];
    final Stack stack = target.inventory.stacks[inventoryIndex];
    if (stack.isEmpty) {
      // concurrent access?
      return;
    }
    final SoftObject objectTaken =
        gameServer.worldManager.world.softObjects[stack.removeLast()];
    final List<int> nItemsToRemove =
        List.filled(target.inventory.stacks.length, 0);
    nItemsToRemove[inventoryIndex] = 1;
    if (stack.isEmpty) {
      target.inventory.stacks.removeAt(inventoryIndex);
    }
    client.session.player.inventory.addItem(objectTaken);

    final removeFromInventoryCommand =
        RemoveFromInventoryCommand(target.id, nItemsToRemove);
    client.sendCommand(removeFromInventoryCommand);

    final serverCommand = AddToInventoryCommand(objectTaken.id);
    client.sendCommand(serverCommand);
  }

  /// Creates a new [TakeFromInventoryCommand] from a JSON object.
  static TakeFromInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$TakeFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TakeFromInventoryCommandToJson(this);
}
