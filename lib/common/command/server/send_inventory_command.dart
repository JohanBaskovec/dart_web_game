import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class SendInventoryCommand extends ServerCommand {
  Inventory inventory;
  List<SoftObject> softObjects;

  SendInventoryCommand(this.inventory, this.softObjects) : super(ServerCommandType.sendInventory);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    world.getSolidObject(inventory.ownerId).inventory = inventory;
    softObjects.forEach(world.addSoftObject);
    if (uiController != null) {
      uiController.displayInventory(world.getSolidObject(inventory.ownerId));
    }
    print('Executed $this');
  }

  /// Creates a new [SendInventoryCommand] from a JSON object.
  static SendInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$SendInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$SendInventoryCommandToJson(this);

  @override
  String toString() {
    return 'SendInventoryCommand{inventory: $inventory, softObjects: $softObjects}';
  }
}
