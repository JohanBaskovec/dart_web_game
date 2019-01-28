import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';

class ClientWorld extends World {
  ClientWorld.fromConstants() {
    tilesColumn = List(worldSize.x);
    solidObjectColumns = List(worldSize.x);
    for (int x = 0; x < worldSize.x; x++) {
      tilesColumn[x] = List(worldSize.y);
    }

    for (int x = 0; x < worldSize.x; x++) {
      solidObjectColumns[x] = List(worldSize.y);
    }
  }
  @override
  void addSolidObject(SolidObject object) {
    assert(object != null);
    assert(object.id != null);
    solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        object.id;
    solidObjects[object.id] = object;
  }

  @override
  void removeSolidObject(SolidObject object) {
    assert(object != null);
    assert(solidObjectColumns[object.tilePosition.x][object.tilePosition.y] !=
        null);
    assert(solidObjects[object.id] != null);
    solidObjectColumns[object.tilePosition.x][object.tilePosition.y] = null;
    solidObjects[object.id] = null;
  }
  @override
  void moveSolidObject(SolidObject object, TilePosition position) {
    assert(object != null);
    assert(position != null);
    solidObjectColumns[object.tilePosition.x][object.tilePosition.y] = null;
    object.moveTo(position);
    solidObjectColumns[position.x][position.y] = object.id;
  }

  @override
  SoftObject addSoftObjectOfType(double quality, SoftObjectType type) {
    assert(type != null);
    final object = SoftObject(quality, type);
    return object;
  }

  @override
  void addSoftObject(SoftObject object) {
    if (object == null) {
      return;
    }
    if (softObjects.length < object.id) {
      softObjects.length = (object.id + 1) * 2;
    }
    softObjects[object.id] = object;
  }

  @override
  void removeSoftObject(SoftObject object) {
    assert(object != null);
    softObjects.removeAt(object.id);
  }

  @override
  void removeSoftObjectId(int id) {
    if (softObjects.length <= id) {
      return;
    }
    softObjects.removeAt(id);
  }

  @override
  void sendCommandToAllClients(ServerCommand command) {
    throw Exception('Can\'t send command to clients from a client!');
  }

  @override
  void update() {
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
  }
}
