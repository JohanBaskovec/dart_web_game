import 'package:dart_game_common/command/command.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_player_command.g.dart';

@JsonSerializable(anyMap: true)
class AddPlayerCommand extends Command {
  String name;
  int id;

  AddPlayerCommand([this.name, this.id]): super(CommandType.AddPlayer);
  
  /// Creates a new [AddPlayerCommand] from a JSON object.
  static AddPlayerCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddPlayerCommandFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$AddPlayerCommandToJson(this);
}