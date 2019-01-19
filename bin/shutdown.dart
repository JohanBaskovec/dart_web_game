import 'dart:io';

import 'package:dart_game/server/read_configuration.dart';
import 'package:yaml/yaml.dart';

Future<void> main() async {
  final client = HttpClient();
  final YamlMap config = readConfiguration();
  final serverUuidFile = File('./data/uuid.txt');
  final serverUuid = serverUuidFile.readAsStringSync();
  const String host = 'localhost';
  final int port = config['backend_port'] as int;
  final String query = 'shutdown=$serverUuid';
  final Uri url = Uri(scheme: 'http', host: host, port: port, query: query);
  print('POST $url');
  final HttpClientRequest request = await client.postUrl(url);
  final HttpClientResponse response = await request.close();
  print(response);
}