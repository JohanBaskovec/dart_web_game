import 'package:dart_game/common/component/rendering_component.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_entity_with_rendering_command.g.dart';

@JsonSerializable(anyMap: true)
class AddEntityWithRenderingCommand extends ServerCommand {
  int entityId;
  RenderingComponent rendering;

  AddEntityWithRenderingCommand() : super(ServerCommandType.addEntityWithRendering);

  /// Creates a new [AddEntityWithRenderingCommand] from a JSON object.
  static AddEntityWithRenderingCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddEntityWithRenderingCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddEntityWithRenderingCommandToJson(this);
}
