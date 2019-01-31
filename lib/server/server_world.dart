import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/server/game_server.dart';

class ServerWorld extends World {
  GameServer gameServer;

  Map<String, int> usernameToIdMap = {};

  ServerWorld.fromConstants() : super.fromConstants();

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

  Entity addEntity(EntityType type) {
    final entity = Entity(type: type);
    entities.add(entity);
    return entity;
  }

  Entity addTree(double nextDouble, int x, int y) {
    print('Adding tree.');
    return addGridAlignedEntity(
        EntityType.gatherable, ImageType.tree, x * tileSize, y * tileSize, 2);
  }

  Entity addEntityWithRendering(
      EntityType type, ImageType image, int x, int y) {
    final Entity entity = addEntity(type);
    addRenderingComponent(x, y, entity, false, image, 1);
    return entity;
  }

  Entity addTile(ImageType image, int x, int y) {
    return addGridAlignedEntity(
        EntityType.ground, image, x * tileSize, y * tileSize, 0);
  }

  Entity addGridAlignedEntity(
      EntityType type, ImageType image, int x, int y, int zIndex) {
    final Entity entity = addEntity(type);
    addGridAlignedRenderingComponent(x, y, entity, image, zIndex);
    print('Added $entity');
    return entity;
  }

  RenderingComponent addGridAlignedRenderingComponent(
      int x, int y, Entity entity, ImageType image, int zIndex) {
    return addRenderingComponent(x, y, entity, true, image, zIndex);
  }

  RenderingComponent addRenderingComponent(int x, int y, Entity entity,
      bool gridAligned, ImageType image, int zIndex) {
    final rendering = RenderingComponent.fromType(
        x: x, y: y, entityId: entity.id, imageType: image);
    renderingComponents.add(rendering);
    entity.renderingComponent = rendering;
    final Tile tile = getTileAt(rendering.tilePosition);

    if (gridAligned && zIndex == 2) {
      tile.solidEntity = entity;
    } else {
      tile.entitiesOnGround.add(entity);
    }
    return rendering;
  }
}
