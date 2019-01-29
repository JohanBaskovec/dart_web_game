import 'dart:typed_data';

import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class LoggedInCommand extends ServerCommand {
  Session session;

  LoggedInCommand(this.session) : super(ServerCommandType.loggedIn);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    print('Executed LoggedInCommand\n');
    session.loggedIn = true;
  }

  @override
  ByteData toBuffer() {
    return null;
  }
}
