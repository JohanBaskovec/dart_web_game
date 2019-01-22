import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class AddSolidObjectCommand extends ServerCommand {
  SolidObject object;

  AddSolidObjectCommand(this.object) : super(ServerCommandType.addSolidObject);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    world.addSolidObject(object);
    print('Executed $this\n');
    if (uiController != null) {
      uiController.updateCraftingMenu();
    }
  }

  /// Creates a new [AddSolidObjectCommand] from a JSON object.
  static AddSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddSolidObjectCommandToJson(this);

  @override
  String toString() {
    return 'AddSolidObjectCommand{object: $object}';
  }
}
