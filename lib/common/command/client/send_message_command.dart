import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_message_command.g.dart';

@JsonSerializable(anyMap: true)
class SendMessageCommand extends ClientCommand {
  String message;

  SendMessageCommand(this.message) : super(ClientCommandType.sendMessage);
  
  /// Creates a new [SendMessageCommand] from a JSON object.
  static SendMessageCommand fromJson(Map<dynamic, dynamic> json) => _$SendMessageCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$SendMessageCommandToJson(this);
}