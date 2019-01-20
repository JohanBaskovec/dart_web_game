import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/send_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'open_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class OpenInventoryCommand extends ClientCommand {
  int ownerId;

  OpenInventoryCommand(this.ownerId) : super(ClientCommandType.openInventory);

  @override
  Future execute(GameClient client, World world) async {
    print('Executing $this\n');
    if (ownerId < 0) {
      print('ownerId below 0.\n');
      return;
    }
    if (ownerId >= world.solidObjects.length) {
      print('ownerId too high.\n');
      return;
    }
    final SolidObject owner = world.getSolidObject(ownerId);
    if (!owner.isAdjacentTo(client.session.player)) {
      print("Trying to get inventory of object that isn't adjacent, cheater?");
      return;
    }
    if (owner.inventory == null) {
      print("Tried to open inventory but object doesn't have one. $owner");
      return;
    }
    if (owner.inventory.private) {
      print('Tried to take from a private inventory,'
          'this shouldn\'t be possible, cheater?');
      return;
    }
    final Inventory inventory = owner.inventory;
    final List<SoftObject> softObjects =
        inventory.items.map((int id) => world.getSoftObject(id)).toList();

    client.sendCommand(SendInventoryCommand(inventory, softObjects));
  }

  /// Creates a new [OpenInventoryCommand] from a JSON object.
  static OpenInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$OpenInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$OpenInventoryCommandToJson(this);

  @override
  String toString() {
    return 'OpenInventoryCommand{ownerId: $ownerId}';
  }
}
