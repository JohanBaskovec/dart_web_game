import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_to_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class AddToInventoryCommand extends ServerCommand {
  SoftGameObject object;

  AddToInventoryCommand(this.object)
      : super(ServerCommandType.addToInventory);

  /// Creates a new [AddToInventoryCommand] from a JSON object.
  static AddToInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddToInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddToInventoryCommandToJson(this);
}
