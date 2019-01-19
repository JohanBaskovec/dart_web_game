import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_to_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class AddToInventoryCommand extends ServerCommand {
  int objectId;

  AddToInventoryCommand(this.objectId)
      : super(ServerCommandType.addToInventory);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    final SoftObject objectTaken = world.getSoftObject(objectId);
    session.player.inventory.addItem(objectTaken);
    print('Executed $this\n');
  }

  /// Creates a new [AddToInventoryCommand] from a JSON object.
  static AddToInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddToInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddToInventoryCommandToJson(this);

  @override
  String toString() {
    return 'AddToInventoryCommand{objectId: $objectId}';
  }


}
