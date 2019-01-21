import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveSolidObjectCommand extends ServerCommand {
  int objectId;
  TilePosition position;

  MoveSolidObjectCommand(this.objectId, this.position)
      : super(ServerCommandType.moveSolidObject);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    final SolidObject object = world.solidObjects[objectId];
    world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        null;
    world.solidObjects[objectId].moveTo(position);
    world.solidObjectColumns[position.x][position.y] = objectId;
    if (uiController != null) {
      uiController.onPlayerMove();
    }

    print('Executed $this\n');
  }

  /// Creates a new [MoveSolidObjectCommand] from a JSON object.
  static MoveSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveSolidObjectCommandToJson(this);

  @override
  String toString() {
    return 'MoveSolidObjectCommand{objectId: $objectId, position: $position}';
  }


}
