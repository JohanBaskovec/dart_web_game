import 'package:dart_game/common/age_component.dart';
import 'package:dart_game/common/command/food_component.dart';
import 'package:dart_game/common/command/server/add_solid_object_command.dart';

import 'package:dart_game/common/command/server/move_solid_object_command.dart';
import 'package:dart_game/common/command/server/remove_solid_object_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/size.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/game_server.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_world.g.dart';


@JsonSerializable(anyMap: true)
class ServerWorld extends World {
  @JsonKey(ignore: true)
  GameServer gameServer;

  Map<String, int> usernameToIdMap = {};

  ServerWorld();

  ServerWorld.fromConstants() {
    tilesColumn = List(worldSize.x);
    solidObjectColumns = List(worldSize.x);
    for (int x = 0; x < worldSize.x; x++) {
      tilesColumn[x] = List(worldSize.y);
    }

    for (int x = 0; x < worldSize.x; x++) {
      solidObjectColumns[x] = List(worldSize.y);
    }
    for (int i = 0; i < worldSize.x * worldSize.y; i++) {
      freeSolidObjectIds.add(i);
    }
  }

  /// Add solid object and send the command to all clients
  @override
  void addSolidObject(SolidObject object) {
    assert(object != null);
    assert(
        freeSolidObjectIds.isNotEmpty,
        'this should never happen, there is exactly enough '
        'space in solidObject to hold every object.');
    final int id = freeSolidObjectIds.removeLast();
    object.id = id;
    final int objectAtPositionId =
        solidObjectColumns[object.tilePosition.x][object.tilePosition.y];
    assert(objectAtPositionId == null);
    solidObjectColumns[object.tilePosition.x][object.tilePosition.y] =
        object.id;
    assert(solidObjects[id] == null);
    solidObjects[id] = object;
    sendCommandToAllClients(AddSolidObjectCommand(object));
    print('addSolidObject $object\n');
  }

  /// Remove solid object and send the command to all clients
  @override
  void removeSolidObjectAndSynchronizeAllClients(SolidObject object) {
    removeSolidObject(object);
    final removeCommand = RemoveSolidObjectCommand(object.id);
    sendCommandToAllClients(removeCommand);
  }

  @override
  void removeSolidObject(SolidObject object) {
    print('removeSolidObject $object\n');
    assert(object != null);
    assert(solidObjectColumns[object.tilePosition.x][object.tilePosition.y] !=
        null);
    assert(solidObjects[object.id] != null);
    solidObjectColumns[object.tilePosition.x][object.tilePosition.y] = null;
    freeSolidObjectIds.add(object.id);
    solidObjects[object.id] = null;
  }


  /// Move solid object and send move command to all clients
  @override
  void moveSolidObject(SolidObject object, TilePosition position) {
    print('moveSolidObject $object to $position\n');
    assert(object != null);
    assert(position != null);
    solidObjectColumns[object.tilePosition.x][object.tilePosition.y] = null;
    object.moveTo(position);
    solidObjectColumns[position.x][position.y] = object.id;
    final serverCommand =
        MoveSolidObjectCommand(object.id, object.tilePosition);
    sendCommandToAllClients(serverCommand);
  }

  SoftObject addApple() {
    final SoftObject apple = addSoftObjectOfType(SoftObjectType.apple);
    apple.foodComponent = FoodComponent(30);
    apple.ageComponent = AgeComponent(minutesPerYear);
    return apple;
  }

  @override
  SoftObject addSoftObjectOfType(SoftObjectType type) {
    assert(type != null);
    final object = SoftObject(type);
    addSoftObject(object);
    switch (type) {
      case SoftObjectType.cookedSnake:
        object.foodComponent = FoodComponent(60);
        break;
      default:
        break;
    }
    return object;
  }

  @override
  Tile addTileOfType(TileType type, int x, int y) {
    final tile = Tile(type);
    tilesColumn[x][y] = tile;
    print('addTileOfType $tile');
    return tile;
  }

  @override
  void addSoftObject(SoftObject object) {
    if (freeSoftObjectIds.isEmpty) {
      object.id = softObjects.length;
      softObjects.add(object);
    } else {
      final int id = freeSoftObjectIds.removeLast();
      object.id = id;
      softObjects[id] = object;
    }
    print('addSoftObject $object\n');
  }

  @override
  void removeSoftObject(SoftObject object) {
    print('removeSoftObject $object\n');
    assert(object != null);
    freeSoftObjectIds.add(object.id);
    softObjects[object.id] = null;
  }

  Size get dimension => worldSize;

  @override
  void sendCommandToAllClients(ServerCommand command) {
    print('sendCommandToAllClients $command\n');
    gameServer.sendCommandToAllClients(command);
  }

  /// Creates a new [ServerWorld] from a JSON object.
  static ServerWorld fromJson(Map<dynamic, dynamic> json) => _$ServerWorldFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$ServerWorldToJson(this);

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
          // Remove without sending to clients because
          // they have their own object update loop
          // that delete dead objects
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
