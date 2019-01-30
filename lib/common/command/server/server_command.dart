import 'dart:typed_data';

import 'package:dart_game/common/command/server/send_world_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

abstract class ServerCommand extends Serializable {
  ServerCommand();

  void execute(Session session, World world, [UiController uiController]);

  static ServerCommand fromBuffer(ByteData data) {
    final ServerCommandType type = ServerCommandType.values[data.getUint8(0)];
    final ByteData bytesOffsetBy1 = ByteData.view(data.buffer, 1);
    switch (type) {
      case ServerCommandType.sendWorld:
        return SendWorldServerCommand.fromBuffer(bytesOffsetBy1);
        break;
      default:
        throw Exception('Not implemented!');
    }
  }
}
