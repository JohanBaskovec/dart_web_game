import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_game/server/client.dart';
import 'package:dart_game/common/command/add_player_command.dart';
import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/command/logged_in_command.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/remove_player_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/world.dart';
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
    final world = World.fromConstants();

    final List<Client> clients = List(MaxPlayers);
    assert(clients.length == world.players.length);

    final HttpServer server =
        await HttpServer.bind(InternetAddress.anyIPv6, 8083);

    int nPlayers = 0;
    server.listen((HttpRequest request) async {
      try {
        if (nPlayers == MaxPlayers) {
          // TODO: ErrorCommand
          return;
        }
        request.response.headers.add('Access-Control-Allow-Origin',
            '${config["frontend_host"]}:${config["frontend_port"]}');
        request.response.headers
            .add('Access-Control-Allow-Credentials', 'true');
        final WebSocket newPlayerWebSocket = await WebSocketTransformer.upgrade(request);
        int playerId;
        for (int i = 0 ; i < clients.length ; i++) {
          if (clients[i] == null) {
            playerId = i;
            break;
          }
        }
        final player = Player('admin', playerId);
        world.players[playerId] = player;
        nPlayers++;
        final newClient = Client(player, newPlayerWebSocket);
        clients[playerId] = newClient;
        // TODO: prevent synchro modification of clients,
        // because we may send wrong id to user otherwise
        final addNewPlayer = AddPlayerCommand(player);
        final loggedInCommand = LoggedInCommand(player, []);
        print('Client connected!');
        for (var i = 0 ; i < clients.length ; i++) {
          if (clients[i] != null) {
            clients[i].webSocket.add(jsonEncode(addNewPlayer));
            loggedInCommand.players.add(world.players[i]);
          }
        }
        final jsonCommand = jsonEncode(loggedInCommand.toJson());
        newPlayerWebSocket.add(jsonCommand);

        newPlayerWebSocket.listen((dynamic data) {
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
                  if (client != null) {
                    client.webSocket.add(jsonEncode(command.toJson()));
                  }
                }
                break;
              case CommandType.Login:
                // TODO
              case CommandType.LoggedIn:
              case CommandType.AddPlayer: // should never happen
              case CommandType.RemovePlayer:
              case CommandType.Unknown:
                print('Error, received unknown command!');
            }
          } else {
            print('Error: command without a type.');
          }
        }, onDone: () {
          print('Client disconnected.');
          final removeCommand = RemovePlayerCommand(playerId);
          for (var client in clients) {
            if (client != null) {
              client.webSocket.add(jsonEncode(removeCommand.toJson()));
            }
          }
          newPlayerWebSocket.close();
          clients[playerId] = null;
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
