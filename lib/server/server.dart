import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_game/common/command/add_player_command.dart';
import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/command/command_from_json.dart';
import 'package:dart_game/common/command/logged_in_command.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/remove_player_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';
import 'package:yaml/yaml.dart';

class Server {
  HttpServer server;
  final List<Client> clients = List(maxPlayers);
  Random randomGenerator = Random.secure();
  World world;

  void sendCommandToAllClients(Command command) {
    for (var client in clients) {
      if (client != null) {
        client.sendCommand(command);
      }
    }
  }

  void executeMoveCommand(MoveCommand command) {
    world.players[command.playerId].position.x += command.x;
    world.players[command.playerId].position.y += command.y;
    sendCommandToAllClients(command);
  }

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

      server = await HttpServer.bind(InternetAddress.anyIPv6, 8083);
      world = World.fromConstants(randomGenerator);

      int nPlayers = 0;
      server.listen((HttpRequest request) async {
        try {
          if (nPlayers == maxPlayers) {
            // TODO: ErrorCommand
            return;
          }
          request.response.headers.add('Access-Control-Allow-Origin',
              '${config["frontend_host"]}:${config["frontend_port"]}');
          request.response.headers
              .add('Access-Control-Allow-Credentials', 'true');
          final WebSocket newPlayerWebSocket =
              await WebSocketTransformer.upgrade(request);
          int playerId;
          for (int i = 0; i < clients.length; i++) {
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
          final loggedInCommand = LoggedInCommand(player, world);
          print('Client connected!');
          for (var i = 0; i < clients.length; i++) {
            if (clients[i] != null) {
              clients[i].webSocket.add(jsonEncode(addNewPlayer));
            }
          }
          final jsonCommand = jsonEncode(loggedInCommand.toJson());
          newPlayerWebSocket.add(jsonCommand);

          newPlayerWebSocket.listen((dynamic data) {
            final Command command = commandFromJson(data as String);
            switch (command.type) {
              case CommandType.move:
                executeMoveCommand(command as MoveCommand);
                break;
              case CommandType.login:
              // TODO
              case CommandType.loggedIn:
              case CommandType.addPlayer: // should never happen
              case CommandType.removePlayer:
              case CommandType.unknown:
                print('Error, received unknown command!');
            }
          }, onDone: () {
            print('Client disconnected.');
            final removeCommand = RemovePlayerCommand(playerId);
            sendCommandToAllClients(removeCommand);
            newPlayerWebSocket.close();
            clients[playerId] = null;
            world.players[playerId] = null;
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
}
