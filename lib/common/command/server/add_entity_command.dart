import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/component/rendering_component.dart';
import 'package:dart_game/common/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_entity_command.g.dart';

@JsonSerializable(anyMap: true)
class AddEntityCommand extends ServerCommand {
  Entity entity;

  AddEntityCommand(this.entity)
      : super(ServerCommandType.addEntity);

  /// Creates a new [AddEntityCommand] from a JSON object.
  static AddEntityCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddEntityCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddEntityCommandToJson(this);
}
