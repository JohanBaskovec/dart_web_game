import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class RemoveSolidObjectCommand extends ServerCommand {
  int id;

  RemoveSolidObjectCommand(this.id)
      : assert(id != null),
        super(ServerCommandType.removeSolidObject);


  @override
  void execute(Session session, World world) {
    world.removeSolidObject(world.getSolidObject(id));
  }

  /// Creates a new [RemoveSolidObjectCommand] from a JSON object.
  static RemoveSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemoveSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RemoveSolidObjectCommandToJson(this);
}
