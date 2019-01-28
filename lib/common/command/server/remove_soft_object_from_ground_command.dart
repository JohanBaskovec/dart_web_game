import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_soft_object_from_ground_command.g.dart';

@JsonSerializable(anyMap: true)
class RemoveSoftObjectFromGroundCommand extends ServerCommand {
  int itemId;

  RemoveSoftObjectFromGroundCommand(this.itemId)
      : super(ServerCommandType.removeSoftObjectFromGround);

  @override
  void execute(Session session, World world, [UiController uiController]) {
    final SoftObject item = world.getSoftObject(itemId);
    item.position = null;
    print('Executed $this\n');
  }

  /// Creates a new [RemoveSoftObjectFromGroundCommand] from a JSON object.
  static RemoveSoftObjectFromGroundCommand fromJson(
          Map<dynamic, dynamic> json) =>
      _$RemoveSoftObjectFromGroundCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() =>
      _$RemoveSoftObjectFromGroundCommandToJson(this);

  @override
  String toString() {
    return 'RemoveSoftObjectFromGroundCommand{itemId: $itemId}';
  }
}
