import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_rendering_and_collision_components_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveRenderingAndCollisionComponentsCommand extends ServerCommand {
  int renderingComponentId;
  int collisionComponentId;
  WorldPosition destination;

  MoveRenderingAndCollisionComponentsCommand(
      this.renderingComponentId, this.collisionComponentId, this.destination)
      : super(ServerCommandType.moveGridAlignedEntity);

  /// Creates a new [MoveRenderingAndCollisionComponentsCommand] from a JSON object.
  static MoveRenderingAndCollisionComponentsCommand fromJson(
          Map<dynamic, dynamic> json) =>
      _$MoveRenderingAndCollisionComponentsCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveRenderingAndCollisionComponentsCommandToJson(this);
}
