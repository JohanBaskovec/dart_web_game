import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:meta/meta.dart';

class MoveEntityServerCommand extends ServerCommand {
  int entityId;
  int entityAreaId;
  int x;
  int y;

  MoveEntityServerCommand(
      {@required this.entityId,
      @required this.entityAreaId,
      @required this.x,
      @required this.y});

  @override
  void execute(Session session, bool serverSide) {
    print('Executed $this\n');
    final Entity entity = world.entities[entityAreaId][entityId];
    if (entity.config.type == RenderingComponentType.solid) {
      final Tile originTile = world.getTileAt(entity.tilePosition);
      final int newX = x ~/ tileSize;
      final int newY = y ~/ tileSize;
      final Tile targetTile = world.getTileAt(TilePosition(newX, newY));
      originTile.solidEntity = null;
      targetTile.solidEntity = entity;
    }
    final int targetAreaIndex = world.getAreaIndex(x, y);

    if (targetAreaIndex != entity.areaId) {
      world.entities.remove(entity);
      world.entities.addToArea(entity, targetAreaIndex);
    }
    entity.moveTo(x, y);
  }

  static const int bufferSize = uint8Bytes + // type
          uint16Bytes + // entityId
          uint16Bytes + // areaId
          int32Bytes + // x
          int32Bytes // y
      ;

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint8(ServerCommandType.moveRenderingComponent.index);
    writer.writeUint16(entityId);
    writer.writeUint16(entityAreaId);
    writer.writeInt32(x);
    writer.writeInt32(y);
  }

  static MoveEntityServerCommand fromByteDataReader(ByteDataReader reader) {
    final command = MoveEntityServerCommand(
        entityId: reader.readUint16(),
        entityAreaId: reader.readUint16(),
        x: reader.readInt32(),
        y: reader.readUint32());
    return command;
  }

  @override
  String toString() {
    return 'MoveRenderingComponentServerCommand{renderingComponentId: $entityId, x: $x, y: $y}';
  }
}
