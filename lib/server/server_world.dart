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

  Entity addEntity() {
    final entity = Entity();
    entities.add(entity);
    return entity;
  }

  Entity addTree(double nextDouble, int x, int y) {
    return addGridAlignedEntity(ImageType.tree, x, y, 2);
  }

  Entity addEntityWithRendering(ImageType image, Box box) {
    final Entity entity = addEntity();
    addRenderingComponent(box, entity, false, image, 1);
    return entity;
  }

  Entity addTile(ImageType image, int x, int y) {
    return addGridAlignedEntity(image, x, y, 0);
  }

  Entity addGridAlignedEntity(ImageType image, int x, int y, int zIndex) {
    final Entity entity = addEntity();
    addGridAlignedRenderingComponent(x, y, entity, image, zIndex);
    print('Added $entity');
    return entity;
  }

  RenderingComponent addGridAlignedRenderingComponent(
      int x, int y, Entity entity, ImageType image, int zIndex) {
    return addRenderingComponent(
        Box.tileBox(x, y), entity, true, image, zIndex);
  }

  RenderingComponent addRenderingComponent(
      Box box, Entity entity, bool gridAligned, ImageType image, int zIndex) {
    final rendering = RenderingComponent(
        box: box,
        entityId: entity.id,
        gridAligned: true,
        imageType: image,
        zIndex: zIndex);
    renderingComponents.add(rendering);
    entity.renderingComponent = rendering;
    return rendering;
  }
}
