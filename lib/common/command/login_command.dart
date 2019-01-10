import 'package:dart_game/common/command/command.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_command.g.dart';

@JsonSerializable(anyMap: true)
class LoginCommand extends Command {
  String name;
  int id;

  LoginCommand([this.name, this.id]): super(CommandType.login);

  /// Creates a new [LoginCommand] from a JSON object.
  static LoginCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoginCommandFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$LoginCommandToJson(this);
}