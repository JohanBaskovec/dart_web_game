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

part 'move_soft_object_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveSoftObjectCommand extends ServerCommand {
  int objectId;
  WorldPosition worldPosition;

  MoveSoftObjectCommand(this.objectId, this.worldPosition)
      : super(ServerCommandType.moveSoftObject);

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

    targetTile.itemsOnGround.add(item.id);
    item.position = worldPosition;
  }

  /// Creates a new [MoveSoftObjectCommand] from a JSON object.
  static MoveSoftObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveSoftObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveSoftObjectCommandToJson(this);

  @override
  String toString() {
    return 'MoveSoftObjectCommand{objectId: $objectId, worldPosition: $worldPosition}';
  }
}
