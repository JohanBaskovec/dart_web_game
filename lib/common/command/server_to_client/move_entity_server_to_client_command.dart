import 'package:dart_game/client/ui/ui.dart' as ui;
import 'package:dart_game/common/command/server/move_entity_server_command.dart';
import 'package:dart_game/common/command/server_to_client/server_to_client_command.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/client/renderer.dart' as renderer;
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:meta/meta.dart';

class MoveEntityServerToClientCommand
    extends ServerToClientCommand<MoveEntityServerCommand> {
  MoveEntityServerToClientCommand(
      {@required MoveEntityServerCommand originalCommand})
      : super(originalCommand: originalCommand);

  @override
  void execute(Session session) {
    final Entity entity = world.entities[originalCommand.entityAreaId][originalCommand.entityId];
    final bool isPlayer = originalCommand.entityId ==
        currentSession.player.id &&
        originalCommand.entityAreaId == currentSession.player.areaId;
    if (!isPlayer) {
      switch (entity.config.type) {
        case RenderingComponentType.item:
          renderer.clearItem(entity);
          break;
        case RenderingComponentType.solid:
          renderer.clearSolidEntity(entity);
          break;
        case RenderingComponentType.ground:
          break;
      }
    }
    originalCommand.execute(session, false);
    ui.dropItemIfDragging(
        id: originalCommand.entityId, areaId: originalCommand.entityAreaId);
    if (isPlayer) {
      renderer.moveCameraToPlayerPosition();
      renderer.paintScene();
    } else {
      switch (entity.config.type) {
        case RenderingComponentType.item:
          renderer.renderItemEntity(entity);
          break;
        case RenderingComponentType.solid:
          renderer.renderSolidEntity(entity);
          break;
        case RenderingComponentType.ground:
          renderer.renderGroundEntity(entity);
          break;
      }
    }
  }
}
