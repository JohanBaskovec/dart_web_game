import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveCommand extends ClientCommand {
  int x;
  int y;
  int playerId;

  MoveCommand([this.x, this.y, this.playerId]): super(ClientCommandType.move);

  /// Creates a new [MoveCommand] from a JSON object.
  static MoveCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveCommandToJson(this);
}

