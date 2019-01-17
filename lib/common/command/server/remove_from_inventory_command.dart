import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_from_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class RemoveFromInventoryCommand extends ServerCommand {
  int ownerId;
  List<int> nObjectsToRemoveFromEachStack;

  RemoveFromInventoryCommand(this.ownerId, this.nObjectsToRemoveFromEachStack)
      : assert(ownerId != null),
        assert(nObjectsToRemoveFromEachStack != null),
        super(ServerCommandType.removeFromInventory);

  void execute(World world) {
      world.solidObjects[ownerId].inventory.removeFromStacks(nObjectsToRemoveFromEachStack);
  }

  /// Creates a new [RemoveFromInventoryCommand] from a JSON object.
  static RemoveFromInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemoveFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RemoveFromInventoryCommandToJson(this);
}
