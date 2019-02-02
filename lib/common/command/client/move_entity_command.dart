import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/move_rendering_component_server_command.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart' as server;

class MoveEntityClientCommand extends ClientCommand {
  int renderingComponentId;
  WorldPosition target;

  MoveEntityClientCommand({this.renderingComponentId, this.target});

  @override
  void execute(GameClient client) {
    print('Executing $this\n');
    final Entity player = client.session.player;
    if (!canExecute(player)) {
      return;
    }
    final Entity entity = world.entities[renderingComponentId];
    final serverCommand = MoveRenderingComponentServerCommand(
        renderingComponentId: entity.renderingComponentId,
        x: target.x,
        y: target.y);
    serverCommand.execute(client.session, true);
    server.sendCommandToAllClients(serverCommand);
  }

  bool canExecute(Entity player) {
    if (renderingComponentId >= world.renderingComponentsByArea.length) {
      print('renderingComponentId is too high.\n');
    }
    if (renderingComponentId < 0) {
      print('renderingComponentId is too low.\n');
    }
    if (!target.isInWorldBound) {
      print('Tried to move entity outside of map.\n');
      return false;
    }

    final TilePosition targetTilePosition = target.toTilePosition();
    final TilePosition playerTilePosition = player.renderingComponent.tilePosition;
    if (!targetTilePosition.isAdjacentTo(playerTilePosition)) {
      print('Entity is too far.\n');
    }
    final Tile tile = world.getTileAt(targetTilePosition);
    if (tile.solidEntity != null) {
      print('Tried to move entity to tile already occupied.\n');
      return false;
    }

    return true;
  }

  int get bufferSize =>
      uint8Bytes +              // type
      uint32Bytes +             // renderingComponentId
      WorldPosition.bufferSize; // WorldPosition

  static MoveEntityClientCommand fromByteDataReader(ByteDataReader reader) {
    final command = MoveEntityClientCommand(
        renderingComponentId: reader.readUint32(),
        target: WorldPosition.fromByteDataReader(reader));
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
    writer.writeUint32(renderingComponentId);
    writer.writeObject(target);
  }
}
