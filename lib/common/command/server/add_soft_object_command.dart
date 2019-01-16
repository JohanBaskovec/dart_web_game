import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_soft_object_command.g.dart';

@JsonSerializable(anyMap: true)
class AddSoftObjectCommand extends ServerCommand {
  SoftObject object;

  AddSoftObjectCommand(this.object)
      : assert(object.id != null),
        super(ServerCommandType.addSoftObject);

  /// Creates a new [AddSoftObjectCommand] from a JSON object.
  static AddSoftObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddSoftObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddSoftObjectCommandToJson(this);
}
