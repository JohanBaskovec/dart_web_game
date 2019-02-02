import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/command/server/move_rendering_component_server_command.dart';
import 'package:dart_game/common/command/server/send_world_server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/common/session.dart';

abstract class ServerCommand extends Serializable {
  ServerCommand();

  void execute(Session session, bool serverSide);

  static ServerCommand fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    final ServerCommandType type = ServerCommandType.values[reader.readUint8()];
    switch (type) {
      case ServerCommandType.sendWorld:
        return SendWorldServerCommand.fromByteDataReader(reader);
      case ServerCommandType.moveRenderingComponent:
        return MoveRenderingComponentServerCommand.fromByteDataReader(reader);
      default:
        throw Exception('Not implemented!');
    }
  }
}
