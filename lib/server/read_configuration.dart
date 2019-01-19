import 'dart:io';

import 'package:yaml/yaml.dart';

YamlMap readConfiguration() {
  const configurationFileName = 'conf.dev.yaml';
  final configurationFile = File(configurationFileName);
  if (!configurationFile.existsSync()) {
    print('${configurationFile.path} does not exist!\n');
  }
  final String configurationFileContent =
  configurationFile.readAsStringSync();
  final YamlMap config = loadYaml(configurationFileContent) as YamlMap;
  return config;
}