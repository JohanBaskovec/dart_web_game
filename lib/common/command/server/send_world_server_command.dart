import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:meta/meta.dart';

class SendWorldServerCommand extends ServerCommand {
  int playerId;
  List<Entity> entities;
  List<RenderingComponent> renderingComponents;

  SendWorldServerCommand(
      {@required this.playerId,
      @required this.entities,
      @required this.renderingComponents});

  @override
  void execute(Session session, World world, [UiController uiController]) {
    print('Executed LoggedInCommand\n');
    session.loggedIn = true;
    for (Entity e in entities) {
      world.entities.add(e);
    }
    for (RenderingComponent e in renderingComponents) {
      world.renderingComponents.add(e);
    }
    for (RenderingComponent renderingComponent in renderingComponents) {
      if (renderingComponent != null &&
          renderingComponent.config.type == RenderingComponentType.solid) {
        final Tile tile = world.getTileAt(renderingComponent.tilePosition);
        final Entity entity = renderingComponent.entity;
        tile.solidEntity = entity;
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
    writer.writeListWithoutNull(entities);
    writer.writeListWithoutNull(renderingComponents);
  }

  int get bufferSize {
    int size = uint8Bytes + // type
        uint32Bytes + // playerId
        uint32Bytes + // entities.length
        uint32Bytes; // renderingComponents.length
    for (Entity e in entities) {
      size += e.bufferSize;
    }
    for (RenderingComponent e in renderingComponents) {
      size += e.bufferSize;
    }
    return size;
  }

  static SendWorldServerCommand fromByteDataReader(ByteDataReader reader) {
    final command = SendWorldServerCommand(
        playerId: reader.readUint32(),
        entities: reader.readListWithoutNull(Entity.fromByteDataReader),
        renderingComponents:
            reader.readListWithoutNull(RenderingComponent.fromByteDataReader));
    return command;
  }

  @override
  String toString() {
    return 'SendWorldServerCommand{playerId: $playerId, entities: $entities, renderingComponents: $renderingComponents}';
  }
}
