import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/command/server/move_entity_server_command.dart';
import 'package:dart_game/common/command/server/send_world_server_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/command/server_to_client/move_entity_server_to_client_command.dart';
import 'package:dart_game/common/command/server_to_client/send_world_server_to_client_command.dart';
import 'package:dart_game/common/session.dart';

class ServerToClientCommand<T extends ServerCommand> {
  T originalCommand;

  ServerToClientCommand({this.originalCommand});

  static ServerToClientCommand fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    final ServerCommandType type = ServerCommandType.values[reader.readUint8()];
    ServerToClientCommand serverToClientCommand;
    switch (type) {
      case ServerCommandType.sendWorld:
        final serverCommand = SendWorldServerCommand.fromByteDataReader(reader);
        serverToClientCommand =
            SendWorldServerToClientCommand(originalCommand: serverCommand);
        break;
      case ServerCommandType.moveEntity:
        final serverCommand =
            MoveEntityServerCommand.fromByteDataReader(reader);
        serverToClientCommand =
            MoveEntityServerToClientCommand(originalCommand: serverCommand);
        break;
      default:
        throw Exception('Not implemented!');
    }
    return serverToClientCommand;
  }

  void execute(Session session) {
    originalCommand.execute(session, false);
  }
}
