import 'package:dart_game/command/command.dart';
import 'package:dart_game/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logged_in_command.g.dart';

@JsonSerializable(anyMap: true)
class LoggedInCommand extends Command {
  Player player;
  List<Player> players;

  LoggedInCommand([this.player, this.players])
      : super(CommandType.LoggedIn);

  /// Creates a new [LoggedInCommand] from a JSON object.
  static LoggedInCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoggedInCommandFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$LoggedInCommandToJson(this);
}
