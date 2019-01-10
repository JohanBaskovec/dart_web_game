import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_game/client.dart';
import 'package:dart_game_common/dart_game_common.dart';
import 'package:dart_game_common/player.dart';
import 'package:yaml/yaml.dart';

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
    final world = World(Size(10, 10));

    final List<Client> clients = [];
    final HttpServer server =
        await HttpServer.bind(InternetAddress.anyIPv6, 8083);
    server.listen((HttpRequest request) async {
      try {
        request.response.headers.add('Access-Control-Allow-Origin',
            '${config["frontend_host"]}:${config["frontend_port"]}');
        request.response.headers
            .add('Access-Control-Allow-Credentials', 'true');
        final WebSocket websocket = await WebSocketTransformer.upgrade(request);
        assert(clients.length == world.players.length);
        final int playerId = clients.length;
        final player = Player('admin', playerId);
        world.players.add(player);
        final client = Client(player, websocket);
        // TODO: prevent synchro modification of clients,
        // because we may send wrong id to user otherwise
        final loginCommand = LoginCommand('admin', playerId);
        final addPlayerCommand = AddPlayerCommand('admin', playerId);
        for (var client in clients) {
          client.webSocket.add(jsonEncode(addPlayerCommand));
        }
        websocket.add(jsonEncode(loginCommand));
        clients.add(client);
        websocket.listen((dynamic data) {
          final Map json = jsonDecode(data as String);
          if (json['type'] != null) {
            final type = commandTypeFromString(json['type'] as String);
            switch (type) {
              case CommandType.Move:
                // TODO: collision etc.
                final command = MoveCommand.fromJson(json);
                world.players[command.playerId].position.x += command.x;
                world.players[command.playerId].position.y += command.y;
                for (var client in clients) {
                  client.webSocket.add(jsonEncode(command));
                }
                break;
              case CommandType.Login:
                // TODO
              case CommandType.AddPlayer: // should never happen
              case CommandType.Unknown:
                print('Error, received unknown command!');
            }
          } else {
            print('Error: command without a type.');
          }
        });
      } catch (e, s) {
        print(e);
        print(s);
      }
    });
  } catch (e, s) {
    print(e);
    print(s);
  }
}
