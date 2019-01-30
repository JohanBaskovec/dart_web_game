import 'dart:typed_data';

import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/client/login_command.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/server/client.dart';

abstract class ClientCommand<T> extends Serializable {
  ClientCommand();

  void execute(GameClient client, World world);

  static ClientCommand fromByteData(ByteData bytes) {
    final ClientCommandType type = ClientCommandType.values[bytes.getUint8(0)];
    final ByteData bytesOffsetBy1 = ByteData.view(bytes.buffer, 1);
    switch (type) {
      case ClientCommandType.login:
        return LoginCommand.fromByteData(bytesOffsetBy1);
        break;
      default:
        throw Exception('Not implemented!');
    }
  }
}
