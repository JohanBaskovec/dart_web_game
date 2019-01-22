import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/command/server/solid_object_summary.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logged_in_command.g.dart';

@JsonSerializable(anyMap: true)
class LoggedInCommand extends ServerCommand {
  Session session;
  List<SoftObject> softObjects;
  List<List<SolidObjectSummary>> solidObjectSummariesColumns;
  SolidObject player;
  List<Message> messages;
  List<List<Tile>> tilesColumn;

  LoggedInCommand(
      this.session,
      this.softObjects,
      this.solidObjectSummariesColumns,
      this.player,
      this.messages,
      this.tilesColumn)
      : assert(softObjects != null),
        assert(player != null),
        assert(solidObjectSummariesColumns != null),
        super(ServerCommandType.loggedIn);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    for (var x = 0; x < solidObjectSummariesColumns.length; x++) {
      final List<SolidObjectSummary> rows = solidObjectSummariesColumns[x];
      for (var y = 0; y < rows.length; y++) {
        final summary = rows[y];
        if (summary == null) {
          continue;
        }
        final object = SolidObject(summary.objectType, TilePosition(x, y));
        object.id = summary.id;
        world.addSolidObject(object);
      }
    }
    world.addSolidObject(player);
    softObjects.forEach(world.addSoftObject);
    world.messages = messages;
    world.tilesColumn = tilesColumn;
    for (int x = 0 ; x < worldSize.x ; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        world.tilesColumn[x][y].box = Box(x * tileSize, y * tileSize, tileSize, tileSize);
        world.tilesColumn[x][y].position = TilePosition(x, y);
      }
    }
    session.playerId = this.session.playerId;
    assert(session.player != null);
    print('Executed LoggedInCommand\n');
    session.loggedIn = true;
  }

  /// Creates a new [LoggedInCommand] from a JSON object.
  static LoggedInCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoggedInCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$LoggedInCommandToJson(this);

  @override
  String toString() {
    return 'LoggedInCommand{session: $session, softObjects: $softObjects, solidObjectSummariesColumns: $solidObjectSummariesColumns, player: $player, messages: $messages, tilesColumn: $tilesColumn}';
  }
}
