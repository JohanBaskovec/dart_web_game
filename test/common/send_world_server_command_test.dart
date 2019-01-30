import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/server/send_world_server_command.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/server/server_world.dart';
import 'package:test/test.dart';

void main() {
  group('Serialization', () {
    test('should work', () {
      final world = ServerWorld.fromConstants();
      world.entities.objects = [
        Entity(
            healthComponentId: null,
            renderingComponentId: 0,
            inventoryComponentId: null,
            world: world),
        null,
        null,
        null,
        Entity(
            healthComponentId: null,
            renderingComponentId: 2,
            inventoryComponentId: null,
            world: world)
      ];
      world.renderingComponents.objects = [
        RenderingComponent(
            box: Box(left: 0, top: 0, width: 1, height: 1),
            entityId: 0,
            gridAligned: false,
            world: world),
        null,
        RenderingComponent(
            box: Box(left: 0, top: 0, width: 1, height: 1),
            entityId: 2,
            gridAligned: false,
            world: world)
      ];
      final command = SendWorldServerCommand(
          playerId: 0,
          entities: world.entities.objects,
          renderingComponents: world.renderingComponents.objects);
      final byteData = command.toByteData();
      final command2 = SendWorldServerCommand.fromByteData(byteData);
    });
  });
}
