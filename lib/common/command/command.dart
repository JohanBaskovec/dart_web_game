import 'package:json_annotation/json_annotation.dart';

part 'command.g.dart';

enum CommandType {
  login,
  loggedIn,
  addPlayer,
  removePlayer,
  move,
  useObjectOnSolidObject,
  removeSolidObject,
  addSolidObject,
  addToInventory,
  removeFromInventory,
  addSoftObject,
  removeSoftObject,
  addTile,
  removeTile,
  buildSolidObject,
  unknown
}

@JsonSerializable(anyMap: true)
class Command {
  CommandType type;

  Command(this.type);

  /// Creates a new [Command] from a JSON object.
  static Command fromJson(Map<dynamic, dynamic> json) =>
      _$CommandFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}