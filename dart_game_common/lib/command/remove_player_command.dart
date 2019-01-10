import 'package:dart_game_common/command/command.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_player_command.g.dart';

@JsonSerializable(anyMap: true)
class RemovePlayerCommand extends Command {
  int id;

  RemovePlayerCommand([this.id]): super(CommandType.AddPlayer);
  
  /// Creates a new [RemovePlayerCommand] from a JSON object.
  static RemovePlayerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemovePlayerCommandFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$RemovePlayerCommandToJson(this);
}