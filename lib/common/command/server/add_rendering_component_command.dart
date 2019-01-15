import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/component/rendering_component.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_rendering_component_command.g.dart';

@JsonSerializable(anyMap: true)
class AddRenderingComponent extends ServerCommand {
  RenderingComponent component;

  AddRenderingComponent(this.component)
      : super(ServerCommandType.addRenderingComponent);

  /// Creates a new [AddRenderingComponent] from a JSON object.
  static AddRenderingComponent fromJson(Map<dynamic, dynamic> json) =>
      _$AddRenderingComponentFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddRenderingComponentToJson(this);
}
