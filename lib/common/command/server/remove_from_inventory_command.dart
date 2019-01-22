import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_from_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class RemoveFromInventoryCommand extends ServerCommand {
  int ownerId;
  List<int> idsToRemove;

  RemoveFromInventoryCommand(this.ownerId, this.idsToRemove)
      : assert(ownerId != null),
        assert(idsToRemove != null),
        super(ServerCommandType.removeFromInventory);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    final Inventory inventory = world.solidObjects[ownerId].inventory;
    idsToRemove.forEach(inventory.items.remove);
    if (uiController != null) {
      uiController.updateCraftingMenu();
    }
    print('Executed $this\n');
  }

  /// Creates a new [RemoveFromInventoryCommand] from a JSON object.
  static RemoveFromInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemoveFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RemoveFromInventoryCommandToJson(this);

  @override
  String toString() {
    return 'RemoveFromInventoryCommand{ownerId: $ownerId, idsToRemove: $idsToRemove}';
  }
}
