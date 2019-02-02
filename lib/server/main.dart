import 'dart:async';

import 'package:dart_game/server/game_server.dart' as server;
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/server/read_configuration.dart';
import 'package:yaml/yaml.dart';

class Server {
  /// Run the application.
  Future<void> run() async {
    try {
      final YamlMap config = readConfiguration();
      world.init();
      server.listen(
        config['backend_port'] as int,
        config['frontend_host'] as String,
        config['frontend_port'] as int,
      );
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
