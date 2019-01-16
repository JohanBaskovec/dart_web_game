import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_player_command.g.dart';

@JsonSerializable(anyMap: true)
class RemovePlayerCommand extends ServerCommand {
  int id;

  RemovePlayerCommand([this.id]): super(ServerCommandType.removePlayer);
  
  /// Creates a new [RemovePlayerCommand] from a JSON object.
  static RemovePlayerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemovePlayerCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RemovePlayerCommandToJson(this);
}