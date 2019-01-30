import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class SendWorldServerCommand extends ServerCommand {
  Entity player;
  List<List<int>> columns;
  List<Entity> entities;
  List<RenderingComponent> renderingComponents;

  SendWorldServerCommand([this.player, this.entities, this.columns]);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    print('Executed LoggedInCommand\n');
    session.loggedIn = true;
    world.solidObjectColumns = columns;
    world.entities.objects = entities;
    session.player = player;


  }

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    player.writeToByteDataWriter(writer);
    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        writer.writeUint32(columns[x][y]);
      }
    }
    for (Entity entity in entities) {
      entity.writeToByteDataWriter(writer);
    }
  }

  int get bufferSize => Entity.bufferSize + // size of player
        (worldSize.x * worldSize.y) * uint32Bytes + // size of each solid object id
        uint32Bytes + // number of entities
        entities.length * Entity.bufferSize;

  static SendWorldServerCommand fromBuffer(ByteData data) {
    final command = SendWorldServerCommand();
    final reader = ByteDataReader(data);
    command.player = Entity.fromByteDataReader(reader);
    command.columns = List(worldSize.x);
    for (int x = 0; x < worldSize.x; x++) {
      command.columns[x] = List(worldSize.y);
    }

    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        command.columns[x][y] = reader.readUint32();
      }
    }
    final int nEntities = reader.readUint32();
    command.entities = List(nEntities);
    for (int i = 0 ; i < nEntities ; i++) {
      command.entities.add(Entity.fromByteDataReader(reader));
    }
    return command;
  }
}
