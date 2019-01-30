import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/ui_controller.dart';

class SendWorldServerCommand extends ServerCommand {
  int playerId;
  List<Entity> entities;
  List<RenderingComponent> renderingComponents;

  SendWorldServerCommand(
      {this.playerId, this.entities, this.renderingComponents});

  @override
  void execute(Session session, World world, [UiController uiController]) {
    print('Executed LoggedInCommand\n');
    session.loggedIn = true;
    world.entities.replaceWith(entities);
    world.renderingComponents.replaceWith(renderingComponents);
    for (RenderingComponent renderingComponent in renderingComponents) {
      if (renderingComponent != null && renderingComponent.gridAligned) {
        final TilePosition position = renderingComponent.box.toTilePosition();
        world.solidObjectColumns[position.x][position.y] =
            renderingComponent.entity;
      }
    }
    session.player = world.entities[playerId];
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
    writer.writeUint32(playerId);
    writer.writeList(entities);
    writer.writeList(renderingComponents);
  }

  int get bufferSize {
    int size = uint8Bytes + // type
        uint32Bytes + // playerId
        uint32Bytes + // entities.length
        entities.length + // at least 1 byte for nullity
        uint32Bytes + // renderingComponents.length
        renderingComponents.length; // at least 1 byte for nullity
    for (Entity e in entities) {
      if (e != null) {
        size += Entity.bufferSize;
      }
    }
    for (RenderingComponent e in renderingComponents) {
      if (e != null) {
        size += RenderingComponent.bufferSize;
      }
    }
    return size;
  }

  static SendWorldServerCommand fromByteDataReader(ByteDataReader reader) {
    final command = SendWorldServerCommand();
    command.playerId = reader.readUint32();
    command.entities = reader.readList(Entity.fromByteDataReader);
    command.renderingComponents =
        reader.readList(RenderingComponent.fromByteDataReader);
    return command;
  }

  @override
  String toString() {
    return 'SendWorldServerCommand{playerId: $playerId, entities: $entities, renderingComponents: $renderingComponents}';
  }
}
