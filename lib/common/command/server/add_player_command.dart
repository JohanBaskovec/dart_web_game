import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_player_command.g.dart';

@JsonSerializable(anyMap: true)
class AddPlayerCommand extends ServerCommand {
  Player player;

  AddPlayerCommand([this.player]): super(ServerCommandType.addPlayer);
  
  /// Creates a new [AddPlayerCommand] from a JSON object.
  static AddPlayerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddPlayerCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddPlayerCommandToJson(this);
}