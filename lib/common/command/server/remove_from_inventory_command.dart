import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_from_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class RemoveFromInventoryCommand extends ServerCommand {
  int ownerId;
  List<int> indexOfObjectsToRemove;

  RemoveFromInventoryCommand(this.ownerId, this.indexOfObjectsToRemove)
      : assert(ownerId != null),
        assert(indexOfObjectsToRemove != null),
        super(ServerCommandType.removeFromInventory);

  void execute(World world) {
    final Inventory inventory = world.solidObjects[ownerId].inventory;
    indexOfObjectsToRemove.forEach(inventory.removeItem);
  }

  /// Creates a new [RemoveFromInventoryCommand] from a JSON object.
  static RemoveFromInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemoveFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RemoveFromInventoryCommandToJson(this);
}
