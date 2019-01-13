import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_message_command.g.dart';

@JsonSerializable(anyMap: true)
class AddMessageCommand extends ServerCommand {
  Message message;

  AddMessageCommand(this.message) : super(ServerCommandType.addMessage);

  /// Creates a new [AddMessageCommand] from a JSON object.
  static AddMessageCommand fromJson(Map<dynamic, dynamic> json) => _$AddMessageCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddMessageCommandToJson(this);
}