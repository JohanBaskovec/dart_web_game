import 'dart:async';
import 'dart:io';

import 'package:dart_game/server/game_server.dart';
import 'package:dart_game/server/read_configuration.dart';
import 'package:yaml/yaml.dart';

class Server {
  /// Run the application.
  Future<void> run() async {
    try {
      final YamlMap config = readConfiguration();
      final gameServer = GameServer.bind(
          config['backend_port'] as int,
          config['frontend_host'] as String,
          config['frontend_port'] as int);

      gameServer.listen();
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
