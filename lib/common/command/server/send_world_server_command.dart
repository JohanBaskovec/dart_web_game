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
import 'package:meta/meta.dart';

class SendWorldServerCommand extends ServerCommand {
  int playerId;
  int playerArea;
  List<List<Entity>> entitiesPerArea;

  SendWorldServerCommand(
      {@required this.playerId,
      @required this.playerArea,
      @required this.entitiesPerArea});

  @override
  void execute(Session session, bool serverSide) {
    print('Executed LoggedInCommand\n');
    session.loggedIn = true;
    world.entities.objects = entitiesPerArea;
    for (List<Entity> entities in entitiesPerArea) {
      for (Entity e in entities) {
        if (e.config.type == RenderingComponentType.solid) {
          final Tile tile = world.getTileAt(e.tilePosition);
          tile.solidEntity = e;
        }
      }
    }
    session.player = world.entities[playerArea][playerId];
  }

  int get bufferSize {
    int size = uint8Bytes + // type
        uint16Bytes + // playerId
        uint16Bytes; // playerArea
    for (List<Entity> entities in entitiesPerArea) {
      size += uint32Bytes; // entities.length
      for (Entity e in entities) {
        size += e.bufferSize;
      }
    }
    return size;
  }


  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint8(ServerCommandType.sendWorld.index);
    writer.writeUint16(playerId);
    writer.writeUint16(playerArea);
    for (int i = 0 ; i < nAreas ; i++) {
      writer.writeUint32(entitiesPerArea[i].length);
      for (Entity t in entitiesPerArea[i]) {
        t.writeToByteDataWriter(writer);
      }
    }
  }

  static SendWorldServerCommand fromByteDataReader(ByteDataReader reader) {
    final int playerId = reader.readUint16();
    final int playerArea = reader.readUint16();
    final List<List<Entity>> entitiesPerAreas = List(nAreas);
    for (int i = 0 ; i < nAreas ; i++) {
      entitiesPerAreas[i] = [];
      final int listSize = reader.readUint32();
      for (int k = 0 ; k < listSize ; k++) {
        entitiesPerAreas[i].add(Entity.fromByteDataReader(reader));
      }
    }

    final command = SendWorldServerCommand(
      playerId: playerId,
      playerArea: playerArea,
      entitiesPerArea: entitiesPerAreas
    );
    return command;
  }
}
