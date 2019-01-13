import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_command.g.dart';

@JsonSerializable(anyMap: true)
class LoginCommand extends ClientCommand {
  String name;
  int id;

  LoginCommand([this.name, this.id]): super(ClientCommandType.login);

  /// Creates a new [LoginCommand] from a JSON object.
  static LoginCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoginCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$LoginCommandToJson(this);
}