import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'click_command.g.dart';

@JsonSerializable(anyMap: true)
class ClickCommand extends ClientCommand {
  int clickableComponentId;

  ClickCommand(this.clickableComponentId): super(ClientCommandType.click);

  /// Creates a new [ClickCommand] from a JSON object.
  static ClickCommand fromJson(Map<dynamic, dynamic> json) =>
      _$ClickCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$ClickCommandToJson(this);
}