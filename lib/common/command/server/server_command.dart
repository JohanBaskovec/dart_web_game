import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/common/session.dart';
import 'package:meta/meta.dart';

abstract class ServerCommand extends Serializable {
  ServerCommandType type;

  ServerCommand({@required this.type});

  void execute(Session session, bool serverSide);
}
