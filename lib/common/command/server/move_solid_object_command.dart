import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveSolidObjectCommand extends ServerCommand {
  int objectId;
  TilePosition position;

  MoveSolidObjectCommand(this.objectId, this.position)
      : super(ServerCommandType.moveSolidObject);

  /// Creates a new [MoveSolidObjectCommand] from a JSON object.
  static MoveSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveSolidObjectCommandToJson(this);
}