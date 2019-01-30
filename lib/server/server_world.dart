import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/server/game_server.dart';

class ServerWorld extends World {
  GameServer gameServer;

  Map<String, int> usernameToIdMap = {};

  ServerWorld.fromConstants() : super.fromConstants() {
    /*
    tilesColumn = List(worldSize.x);
    for (int x = 0; x < worldSize.x; x++) {
      tilesColumn[x] = List(worldSize.y);
    }
    */
    /*
    for (int i = 0; i < worldSize.x * worldSize.y; i++) {
      freeSolidObjectIds.add(i);
    }
    */
  }

  @override
  void sendCommandToAllClients(ServerCommand command) {
    print('sendCommandToAllClients $command\n');
    gameServer.sendCommandToAllClients(command);
  }

  @override
  void update() {
    /*
    final start = DateTime.now();
    for (int i = 0; i < solidObjects.length; i++) {
      final SolidObject object = solidObjects[i];

      if (object != null) {
        if (object.hungerComponent != null) {
          object.hungerComponent.update(this);
        }
        if (object.ageComponent != null) {
          object.ageComponent.update(this);
        }

        if (!object.alive) {
          // Remove without sending to clients because
          // they have their own object update loop
          // that delete dead objects
          final command = RemoveSolidObjectCommand(object.id);
          sendCommandToAllClients(command);
          removeSolidObject(object);
        }
      }
    }

    for (int i = 0; i < softObjects.length; i++) {
      final SoftObject object = softObjects[i];

      if (object != null) {
        if (object.ageComponent != null) {
          object.ageComponent.update(this);
        }

        if (!object.alive) {
          removeSoftObject(object);
        }
      }
    }
    final end = DateTime.now();
    final diff = end.difference(start);
    print('Updated all solid objects in $diff\n');
    */
  }

  Entity addTree(double nextDouble, int x, int y) {
    final entity = Entity();
    entities.add(entity);
    final rendering = RenderingComponent(
        box: Box.tileBox(x, y),
        entityId: entity.id,
        gridAligned: true,
        imageType: ImageType.tree);
    renderingComponents.add(rendering);
    entity.renderingComponent = rendering;
    print('Added $entity');
    return entity;
  }
}
