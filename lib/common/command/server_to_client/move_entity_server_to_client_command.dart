import 'package:dart_game/client/ui/client_ui_controller.dart' as ui;
import 'package:dart_game/common/command/server/move_entity_server_command.dart';
import 'package:dart_game/common/command/server_to_client/server_to_client_command.dart';
import 'package:dart_game/common/session.dart';
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
  }
}
