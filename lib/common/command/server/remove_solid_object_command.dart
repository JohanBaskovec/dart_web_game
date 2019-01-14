import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class RemoveEntityCommand extends ServerCommand {
  TilePosition position;

  RemoveEntityCommand(this.position)
      : super(ServerCommandType.removeEntity);

  /// Creates a new [RemoveEntityCommand] from a JSON object.
  static RemoveEntityCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemoveEntityCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RemoveEntityCommandToJson(this);
}
