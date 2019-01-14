import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class AddEntityCommand extends ServerCommand {
  Entity object;

  AddEntityCommand(this.object) : super(ServerCommandType.addEntity);

  /// Creates a new [AddEntityCommand] from a JSON object.
  static AddEntityCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddEntityCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddEntityCommandToJson(this);
}