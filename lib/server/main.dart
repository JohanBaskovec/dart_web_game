import 'dart:async';
import 'dart:io';

import 'package:dart_game/server/game_server.dart';
import 'package:dart_game/server/world_manager.dart';
import 'package:yaml/yaml.dart';

class Server {
  /// Run the application.
  Future<void> run() async {
    try {
      const configurationFileName = 'conf.dev.yaml';
      final configurationFile = File(configurationFileName);
      if (!configurationFile.existsSync()) {
        print('${configurationFile.path} does not exist!');
      }
      final String configurationFileContent =
          configurationFile.readAsStringSync();
      final YamlMap config = loadYaml(configurationFileContent) as YamlMap;

      final worldManager = WorldManager();

      final gameServer = GameServer.bind(
          config['backend_port'] as int,
          config['frontend_host'] as String,
          config['frontend_port'] as int,
          worldManager);

      worldManager.fillWorldWithStuff();
      worldManager.startObjectsUpdate();
      gameServer.listen();
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
