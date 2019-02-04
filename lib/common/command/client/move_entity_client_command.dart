import 'dart:typed_data';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/move_entity_server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart' as server;
import 'package:meta/meta.dart';

/// Command to move an entity by x pixels to the right,
/// and y pixels to the bottom.
/// The entity must be an item, and must be on a tile adjacent
/// to the player.
/// The target location must not put the entity's box outside
/// of the tiles around the players.
class MoveEntityClientCommand extends ClientCommand {
  int entityAreaId;
  int entityId;
  int x;
  int y;

  MoveEntityClientCommand(
      {@required this.entityAreaId,
      @required this.entityId,
      @required this.x,
      @required this.y});

  @override
  void execute(GameClient client) {
    print('Executing $this\n');
    final Entity player = client.session.player;
    if (!canExecute(player)) {
      return;
    }
    final Entity entity = world.entities[entityAreaId][entityId];
    final serverCommand = MoveEntityServerCommand(
        entityId: entityId,
        entityAreaId: entityAreaId,
        x: entity.box.left + x,
        y: entity.box.top + y);
    serverCommand.execute(client.session, true);
    server.sendCommandToAllClients(serverCommand);
  }

  bool canExecute(Entity player) {
    if (entityAreaId < 0) {
      print('entityAreaId too low.\n');
      return false;
    }
    if (entityAreaId >= world.entities.length) {
      print('entityAreaId too high.\n');
      return false;
    }
    final List<Entity> entitiesInArea = world.entities[entityAreaId];
    if (entityId < 0) {
      print('entityId too low.\n');
      return false;
    }
    if (entityId > entitiesInArea.length) {
      print('entityId too high.\n');
      return false;
    }

    final Entity entity = entitiesInArea[entityId];
    if (entity.config.type != RenderingComponentType.item) {
      print('Can only move items!');
      return false;
    }
    final TilePosition entityTilePosition = entity.tilePosition;
    final playerTilePosition = player.box.toTilePosition();

    if (!entityTilePosition.isAdjacentTo(playerTilePosition)) {
      print('Entity too far.\n');
      return false;
    }

    final targetBox = Box(
        left: entity.box.left + x,
        top: entity.box.top + y,
        width: entity.box.width,
        height: entity.box.height);
    final boxAroundPlayer = Box(
      left: (playerTilePosition.x - 1) * tileSize,
      top: (playerTilePosition.y - 1) * tileSize,
      width: tileSize * 3,
      height: tileSize * 3
    );
    boxAroundPlayer.clamp(worldBoxPx);
    if (!boxAroundPlayer.contains(targetBox)) {
      print('Moving the entity would put it out of range.\n');
      return false;
    }

    final TilePosition targetTilePosition = targetBox.toTilePosition();
    final Tile tile = world.tiles[targetTilePosition.x][targetTilePosition.y];
    if (tile.solidEntity != null) {
      print('Tried to move to tile already occupied.\n');
      return false;
    }
    return true;
  }

  int get bufferSize =>
      uint8Bytes + // type
      uint16Bytes + // entityId
      uint16Bytes + // entityAreaId
      int8Bytes + // x
      int8Bytes; // y

  static MoveEntityClientCommand fromByteDataReader(ByteDataReader reader) {
    final command = MoveEntityClientCommand(
        entityId: reader.readUint16(),
        entityAreaId: reader.readUint16(),
        x: reader.readInt8(),
        y: reader.readInt8());
    return command;
  }

  @override
  ByteData toByteData() {
    final ByteDataWriter writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint8(ClientCommandType.moveEntity.index);
    writer.writeUint16(entityId);
    writer.writeUint16(entityAreaId);
    writer.writeInt8(x);
    writer.writeInt8(y);
  }
}
