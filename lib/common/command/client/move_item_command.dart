import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/move_soft_object_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile.dart';
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
    final tilePos = position.toTilePosition();
    final Tile tile = world.getTileAt(tilePos);
    print(tile);
    if (tilePos.x >= worldSize.x ||
        tilePos.x < 0 && tilePos.y >= worldSize.y && tilePos.y < 0) {
      print('Tried to Move item on tile outside of map.\n');
      return;
    }
    if (!player.isAdjacentToPosition(tilePos)) {
      print('Target position is too far.\n');
      return;
    }
    if (world.getObjectAt(tilePos) != null) {
      print('Tried to Move item on tile occupied by solid object!\n');
      return;
    }
    final SoftObject item = world.getSoftObject(itemId);
    final TilePosition itemCurrentTilePosition = item.position.toTilePosition();
    if (!player.isAdjacentToPosition(itemCurrentTilePosition)) {
      print('Item current position is too far.\n');
      return;
    }

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
