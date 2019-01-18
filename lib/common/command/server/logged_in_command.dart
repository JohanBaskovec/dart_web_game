import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/server/server_world.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logged_in_command.g.dart';

@JsonSerializable(anyMap: true)
class LoggedInCommand extends ServerCommand {
  int playerId;
  World world;

  LoggedInCommand([this.playerId, this.world])
      : super(ServerCommandType.loggedIn);

  @override
  void execute(Session session, World world) {
    world.softObjects = this.world.softObjects;
    world.solidObjects = this.world.solidObjects;
    world.solidObjectColumns = this.world.solidObjectColumns;
    world.tilesColumn = this.world.tilesColumn;
    session.player = this.world.solidObjects[playerId];
    assert(session.player != null);
    session.player = this.world.solidObjects[playerId];
  }

  /// Creates a new [LoggedInCommand] from a JSON object.
  static LoggedInCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoggedInCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$LoggedInCommandToJson(this);
}
