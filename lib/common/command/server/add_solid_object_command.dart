import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class AddSolidObjectCommand extends ServerCommand {
  SolidGameObject object;

  AddSolidObjectCommand(this.object) : super(ServerCommandType.addSolidObject);

  /// Creates a new [AddSolidObjectCommand] from a JSON object.
  static AddSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddSolidObjectCommandToJson(this);
}