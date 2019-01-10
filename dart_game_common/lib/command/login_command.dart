import 'package:dart_game_common/command/command.dart';
import 'package:dart_game_common/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_command.g.dart';

@JsonSerializable(anyMap: true)
class LoginCommand extends Command {
  String name;
  int id;

  LoginCommand([this.name, this.id]): super(CommandType.Login);

  /// Creates a new [LoginCommand] from a JSON object.
  static LoginCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoginCommandFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$LoginCommandToJson(this);
}