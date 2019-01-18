import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/set_equipped_item_server_command.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_equipped_item_client_command.g.dart';

@JsonSerializable(anyMap: true)
class SetEquippedItemClientCommand extends ClientCommand {
  int inventoryIndex;

  SetEquippedItemClientCommand(this.inventoryIndex)
      : super(ClientCommandType.setEquippedItem);

  @override
  void execute(GameClient client, World world) {
    final int itemId = client.session.player.inventory.items[inventoryIndex];
    client.session.player.inventory.currentlyEquiped = itemId;
    final serverCommand = SetEquippedItemServerCommand(itemId);
    client.sendCommand(serverCommand);
    print('Executed $this');
  }

  /// Creates a new [SetEquippedItemClientCommand] from a JSON object.
  static SetEquippedItemClientCommand fromJson(Map<dynamic, dynamic> json) =>
      _$SetEquippedItemClientCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$SetEquippedItemClientCommandToJson(this);

  @override
  String toString() {
    return 'SetEquippedItemClientCommand{inventoryIndex: $inventoryIndex}';
  }
}
