import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/add_soft_object_command.dart';
import 'package:dart_game/common/command/server/move_soft_object_command.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_item_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveItemCommand extends ClientCommand {
  WorldPosition position;
  int itemId;

  MoveItemCommand(this.position, this.itemId)
      : super(ClientCommandType.moveItem);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    final SolidObject player = client.session.player;
    final tilePos =
        TilePosition(position.x ~/ tileSize, position.y ~/ tileSize);
    if (tilePos.x >= worldSize.x ||
        tilePos.x < 0 && tilePos.y >= worldSize.y && tilePos.y < 0) {
      print('Tried to Move item on tile outside of map.\n');
      return;
    }
    if (!player.isAdjacentToPosition(tilePos)) {
      print('Position is too far.');
      return;
    }
    if (world.getObjectAt(tilePos) != null) {
      print('Tried to Move item on tile occupied by solid object!');
      return;
    }
    if (!player.inventory.contains(itemId)) {
      print("Player inventory doesn't contain $itemId\n");
      return;
    }
    final removeCommand = RemoveFromInventoryCommand(player.id, [itemId]);
    removeCommand.execute(client.session, world);
    client.sendCommand(removeCommand);

    final SoftObject item = world.getSoftObject(itemId);
    // we have to do this because the item is moved from inventory to
    // the ground, and items in player's inventory aren't in the client's
    // list of items
    world.sendCommandToAllClients(AddSoftObjectCommand(item));
    final moveCommand = MoveSoftObjectCommand(itemId, position);
    moveCommand.execute(client.session, world);
    world.sendCommandToAllClients(moveCommand);
  }

  /// Creates a new [MoveItemCommand] from a JSON object.
  static MoveItemCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveItemCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveItemCommandToJson(this);

  @override
  String toString() {
    return 'MoveItemCommand{position: $position, itemId: $itemId}';
  }
}
