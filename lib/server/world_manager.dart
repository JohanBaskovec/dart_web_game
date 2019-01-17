import 'dart:async';
import 'dart:math';

import 'package:dart_game/common/command/server/add_solid_object_command.dart';
import 'package:dart_game/common/command/server/logged_in_command.dart';
import 'package:dart_game/common/command/server/move_solid_object_command.dart';
import 'package:dart_game/common/command/server/remove_solid_object_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/hunger_component.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/game_server.dart';

class WorldManager {
  Random randomGenerator = Random.secure();
  World world = World.fromConstants();
  GameServer gameServer;

  WorldManager();

  SolidObject getObjectAt(TilePosition position) {
    return world.getObjectAt(position);
  }

  void startObjectsUpdate() {
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      final start = DateTime.now();
      for (int i = 0; i < world.solidObjects.length; i++) {
        final SolidObject object = world.solidObjects[i];

        if (object != null) {
          if (object.hungerComponent != null) {
            object.hungerComponent.update(world);
          }
          if (object.ageComponent != null) {
            object.ageComponent.update(world);
          }

          if (!object.alive) {
            removeSolidObject(object);
          }
        }
      }
      for (int i = 0; i < world.softObjects.length; i++) {
        final SoftObject object = world.softObjects[i];

        if (object != null) {
          if (object.ageComponent != null) {
            object.ageComponent.update(world);
          }

          if (!object.alive) {
            removeSoftObject(object);
          }
        }
      }
      final end = DateTime.now();
      final diff = end.difference(start);
      print('Updated all solid objects in $diff');
    });
  }

  /// Add solid object and send the command to all clients
  void addSolidObject(SolidObject object) {
    assert(object != null);
    assert(
        world.freeSolidObjectIds.isNotEmpty,
        'this should never happen, there is exactly enough '
        'space in solidObject to hold every object.');
    final int id = world.freeSolidObjectIds.removeLast();
    object.id = id;
    final int objectAtPositionId =
        world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y];
    assert(objectAtPositionId == null);
    world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        object.id;
    assert(world.solidObjects[id] == null);
    world.solidObjects[id] = object;
    sendCommandToAllClients(AddSolidObjectCommand(object));
  }

  /// Remove solid object and send the command to all clients
  void removeSolidObject(SolidObject object) {
    assert(object != null);
    assert(world.solidObjectColumns[object.tilePosition.x]
            [object.tilePosition.y] !=
        null);
    assert(world.solidObjects[object.id] != null);
    world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        null;
    world.freeSolidObjectIds.add(object.id);
    world.solidObjects[object.id] = null;

    final removeCommand = RemoveSolidObjectCommand(object.id);
    sendCommandToAllClients(removeCommand);
  }

  /// Move solid object and send move command to all clients
  void moveSolidObject(SolidObject object, TilePosition position) {
    assert(object != null);
    assert(position != null);
    world.solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        null;
    object.moveTo(position);
    world.solidObjectColumns[position.x][position.y] = object.id;
    final serverCommand =
        MoveSolidObjectCommand(object.id, object.tilePosition);
    sendCommandToAllClients(serverCommand);
  }

  SoftObject addSoftObject(SoftObjectType type) {
    assert(type != null);
    final object = SoftObject(type);
    if (world.freeSoftObjectIds.isEmpty) {
      object.id = world.softObjects.length;
      world.softObjects.add(object);
    } else {
      final int id = world.freeSoftObjectIds.removeLast();
      object.id = id;
      world.softObjects[id] = object;
    }
    return object;
  }

  void removeSoftObject(SoftObject object) {
    assert(object != null);
    world.freeSoftObjectIds.add(object.id);
    world.softObjects.removeAt(object.id);
  }

  SolidObject addNewPlayerAtRandomPosition() {
    SolidObject newPlayer;
    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        if (world.solidObjectColumns[x][y] == null) {
          newPlayer = makePlayer(x, y);
          break;
        }
      }
      if (newPlayer != null) {
        break;
      }
    }
    if (newPlayer != null) {
      newPlayer.hungerComponent = HungerComponent(0, 1);
      newPlayer.inventory.addItem(addSoftObject(SoftObjectType.hand));
      newPlayer.inventory.addItem(addSoftObject(SoftObjectType.axe));
      newPlayer.inventory.addItem(addSoftObject(SoftObjectType.log));
      newPlayer.inventory.addItem(addSoftObject(SoftObjectType.leaves));
      newPlayer.inventory.addItem(addSoftObject(SoftObjectType.leaves));
      addSolidObject(newPlayer);
    }
    return newPlayer;
  }

  void fillWorldWithStuff() {
    for (int x = 0; x < world.solidObjectColumns.length; x++) {
      for (int y = 0; y < world.solidObjectColumns[x].length; y++) {
        final int rand = randomGenerator.nextInt(100);
        if (rand < 40) {
          final tree = makeTree(x, y);
          addSolidObject(tree);
          final int nLeaves = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLeaves; i++) {
            final leaves = addSoftObject(SoftObjectType.leaves);
            tree.inventory.addItem(leaves);
          }

          final int nSnakes = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nSnakes; i++) {
            final snake = addSoftObject(SoftObjectType.snake);
            tree.inventory.addItem(snake);
          }
        } else if (rand < 80) {
          final tree = makeAppleTree(x, y);
          addSolidObject(tree);
          final int nApples = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nApples; i++) {
            tree.inventory.addItem(addSoftObject(SoftObjectType.apple));
          }
        }
      }
    }
  }

  void sendCommandToAllClients(ServerCommand command) {
    gameServer.sendCommandToAllClients(command);
  }
}
