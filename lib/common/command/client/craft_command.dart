import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/add_to_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'craft_command.g.dart';

@JsonSerializable(anyMap: true)
class CraftCommand extends ClientCommand {
  SoftObjectType objectType;

  CraftCommand(this.objectType) : super(ClientCommandType.craft);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    final SolidObject player = client.session.player;
    if (!playerCanCraft(world, objectType, player)) {
      print("Player can't craft $objectType\n");
      return;
    }

    final Map<SoftObjectType, int> recipe =
        craftingRecipes[objectType].requiredItems;
    removeItemsFromInventory(client, recipe, world);
    final SoftObject craftedItem = world.addSoftObjectOfType(objectType);
    final addSoftObjectCommand = AddSoftObjectCommand(craftedItem);
    client.sendCommand(addSoftObjectCommand);
    final addToInventoryCommand =
        AddToInventoryCommand(player.id, craftedItem.id);
    addToInventoryCommand.execute(client.session, world);
    client.sendCommand(addToInventoryCommand);
  }

  /// Creates a new [CraftCommand] from a JSON object.
  static CraftCommand fromJson(Map<dynamic, dynamic> json) =>
      _$CraftCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$CraftCommandToJson(this);

  @override
  String toString() {
    return 'CraftCommand{objectType: $objectType}';
  }
}
