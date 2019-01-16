import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_player_command.g.dart';

@JsonSerializable(anyMap: true)
class MovePlayerCommand extends ServerCommand {
  TilePosition targetPosition;
  int playerId;

  MovePlayerCommand(this.playerId, this.targetPosition)
      : super(ServerCommandType.movePlayer);
  
  /// Creates a new [MovePlayerCommand] from a JSON object.
  static MovePlayerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MovePlayerCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MovePlayerCommandToJson(this);
}
