import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile_position.dart';

class ClientWorld extends World {
  @override
  void addSolidObject(SolidObject object) {
    assert(object != null);
    final int objectAtPositionId =
        solidObjectColumns[object.tilePosition.x][object.tilePosition.y];
    assert(objectAtPositionId == null);
    solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        object.id;
    assert(solidObjects[object.id] == null);
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
  SoftObject addSoftObjectOfType(SoftObjectType type) {
    assert(type != null);
    final object = SoftObject(type);
    return object;
  }

  @override
  void addSoftObject(SoftObject object) {
    if (softObjects.length < object.id) {
      softObjects.length *= 2;
    }
    softObjects[object.id] = object;
  }

  @override
  void removeSoftObject(SoftObject object) {
    assert(object != null);
    softObjects.removeAt(object.id);
  }

  @override
  void sendCommandToAllClients(ServerCommand command) {
    throw Exception('Can\'t send command to clients from a client!');
  }


}
