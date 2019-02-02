import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/move_rendering_component_server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart' as server;


class MoveClientCommand extends ClientCommand {
  int x;
  int y;

  MoveClientCommand({this.x, this.y});

  @override
  void execute(GameClient client) {
    print('Executing $this\n');
    final Entity player = client.session.player;
    if (!canExecute(player)) {
      return;
    }
    final serverCommand = MoveRenderingComponentServerCommand(
        renderingComponentId: client.session.player.renderingComponentId,
        x: player.renderingComponent.box.left + x * tileSize,
        y: player.renderingComponent.box.top + y * tileSize);
    serverCommand.execute(client.session, true);
    server.sendCommandToAllClients(serverCommand);
  }

  bool canExecute(Entity player) {
    final currentPosition = player.renderingComponent.box.toTilePosition();
    final target = TilePosition(currentPosition.x + x, currentPosition.y + y);
    if (!target.isInWorldBound) {
      print('Tried to move to tile outside of map.\n');
      return false;
    }

    final Tile tile = world.getTileAt(target);
    if (tile.solidEntity != null) {
      print('Tried to move to tile already occupied.\n');
      return false;
    }
    return true;
  }

  int get bufferSize =>
      uint8Bytes + // type
      int8Bytes + // x
      int8Bytes; // y

  static MoveClientCommand fromByteDataReader(ByteDataReader reader) {
    final command =
        MoveClientCommand(x: reader.readInt8(), y: reader.readInt8());
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
    writer.writeUint8(ClientCommandType.move.index);
    writer.writeInt8(x);
    writer.writeInt8(y);
  }
}
