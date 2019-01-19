import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_soft_object_command.g.dart';

@JsonSerializable(anyMap: true)
class AddSoftObjectCommand extends ServerCommand {
  SoftObject object;

  AddSoftObjectCommand(this.object)
      : assert(object != null),
        super(ServerCommandType.addSoftObject);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    world.addSoftObject(object);
    print('Executed $this');
  }

  /// Creates a new [AddSoftObjectCommand] from a JSON object.
  static AddSoftObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddSoftObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddSoftObjectCommandToJson(this);

  @override
  String toString() {
    return 'AddSoftObjectCommand{object: $object}';
  }
}
