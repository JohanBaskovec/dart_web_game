import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'drop_soft_object_server_command.g.dart';

@JsonSerializable(anyMap: true)
class DropSoftObjectServerCommand extends ServerCommand {
  int objectId;
  WorldPosition worldPosition;

  DropSoftObjectServerCommand(this.objectId, this.worldPosition)
      : super(ServerCommandType.dropSoftObject);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    print('Executed $this\n');
    final Tile targetTile = world.getTileAt(worldPosition.toTilePosition());
    final SoftObject item = world.getSoftObject(objectId);
    if (item.position != null) {
      final TilePosition originalPosition = item.position.toTilePosition();
      final Tile originalTile = world.getTileAt(originalPosition);
      originalTile.itemsOnGround.remove(objectId);
    }

    item.ownerId = null;
    item.indexInInventory = null;
    targetTile.itemsOnGround.add(item.id);
    item.position = worldPosition;

    if (uiController != null) {
      uiController.dropItemIfDragging(item.id);
    }
  }

  /// Creates a new [DropSoftObjectServerCommand] from a JSON object.
  static DropSoftObjectServerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$DropSoftObjectServerCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$DropSoftObjectServerCommandToJson(this);

  @override
  String toString() {
    return 'DropSoftObjectServerCommand{objectId: $objectId, worldPosition: $worldPosition}';
  }
}
