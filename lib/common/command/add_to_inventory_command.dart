import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_to_inventory_command.g.dart';

@JsonSerializable(anyMap: true)
class AddToInventoryCommand extends Command {
  int playerId;
  SoftGameObject object;

  AddToInventoryCommand(this.playerId, this.object)
      : super(CommandType.addToInventory);

  /// Creates a new [AddToInventoryCommand] from a JSON object.
  static AddToInventoryCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddToInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddToInventoryCommandToJson(this);
}