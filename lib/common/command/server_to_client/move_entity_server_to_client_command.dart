import 'package:dart_game/client/ui/ui.dart' as ui;
import 'package:dart_game/common/command/server/move_entity_server_command.dart';
import 'package:dart_game/common/command/server_to_client/server_to_client_command.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/client/renderer.dart' as renderer;
import 'package:meta/meta.dart';

class MoveEntityServerToClientCommand
    extends ServerToClientCommand<MoveEntityServerCommand> {
  MoveEntityServerToClientCommand(
      {@required MoveEntityServerCommand originalCommand})
      : super(originalCommand: originalCommand);

  @override
  void execute(Session session) {
    originalCommand.execute(session, false);
    ui.dropItemIfDragging(
        id: originalCommand.entityId, areaId: originalCommand.entityAreaId);
    renderer.paintScene();
  }
}
