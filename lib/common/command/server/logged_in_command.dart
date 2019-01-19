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
  int playerId;
  Inventory playerInventory;
  List<SoftObject> softObjects;
  List<List<SolidObjectSummary>> solidObjectSummariesColumns;

  LoggedInCommand(this.playerId, this.playerInventory, this.softObjects,
      this.solidObjectSummariesColumns)
      : assert(playerId != null),
        assert(playerInventory != null),
        assert(softObjects != null),
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
    session.player = world.getSolidObject(playerId);
    session.player.inventory = playerInventory;
    assert(session.player != null);
    print('Executed LoggedInCommand\n');
  }

  /// Creates a new [LoggedInCommand] from a JSON object.
  static LoggedInCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoggedInCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$LoggedInCommandToJson(this);

  @override
  String toString() {
    return 'LoggedInCommand{playerId: $playerId, playerInventory: $playerInventory, softObjects: $softObjects, solidObjectSummariesColumns: $solidObjectSummariesColumns}';
  }
}
