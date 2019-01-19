import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/command/server/solid_object_summary.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logged_in_command.g.dart';

@JsonSerializable(anyMap: true)
class LoggedInCommand extends ServerCommand {
  Session session;
  List<SoftObject> softObjects;
  List<List<SolidObjectSummary>> solidObjectSummariesColumns;
  Inventory inventory;

  LoggedInCommand( this.session, this.softObjects, this.solidObjectSummariesColumns, this.inventory)
      : assert(softObjects != null),
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
    softObjects.forEach(world.addSoftObject);
    session.playerId = this.session.playerId;
    session.player.inventory = inventory;
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
    return 'LoggedInCommand{session: $session, softObjects: $softObjects, solidObjectSummariesColumns: $solidObjectSummariesColumns}';
  }
}
