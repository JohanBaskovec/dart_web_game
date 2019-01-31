import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/client/login_client_command.dart';
import 'package:dart_game/common/command/client/move_client_command.dart';
import 'package:dart_game/common/command/client/move_entity_command.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/server/client.dart';

abstract class ClientCommand<T> extends Serializable {
  ClientCommand();

  void execute(GameClient client, World world);

  static ClientCommand fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    final ClientCommandType type = ClientCommandType.values[reader.readUint8()];
    switch (type) {
      case ClientCommandType.login:
        return LoginClientCommand.fromByteDataReader(reader);
        break;
      case ClientCommandType.move:
        return MoveClientCommand.fromByteDataReader(reader);
      case ClientCommandType.moveEntity:
        return MoveEntityClientCommand.fromByteDataReader(reader);
      default:
        throw Exception('Not implemented!');
    }
  }
}
