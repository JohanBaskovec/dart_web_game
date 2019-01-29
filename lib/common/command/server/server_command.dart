import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

abstract class ServerCommand extends Serializable {
  ServerCommandType type;

  ServerCommand(this.type);

  void execute(Session session, World world, [UiController uiController]);
}
