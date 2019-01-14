import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_grid_aligned_entity_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveGridAlignedEntityCommand extends ServerCommand {
  int entityId;
  TilePosition destination;

  MoveGridAlignedEntityCommand(this.entityId, this.destination)
      : super(ServerCommandType.moveGridAlignedEntity);

  /// Creates a new [MoveGridAlignedEntityCommand] from a JSON object.
  static MoveGridAlignedEntityCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveGridAlignedEntityCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveGridAlignedEntityCommandToJson(this);
}
