import 'package:dart_game/command/command.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveCommand extends Command {
  int x;
  int y;
  int playerId;

  MoveCommand([this.x, this.y, this.playerId]): super(CommandType.Move);

  /// Creates a new [MoveCommand] from a JSON object.
  static MoveCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveCommandFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$MoveCommandToJson(this);
}

