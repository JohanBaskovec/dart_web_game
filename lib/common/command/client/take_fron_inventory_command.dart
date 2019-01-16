import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'take_from_inventory.g.dart';

@JsonSerializable(anyMap: true)
class TakeFromInventoryCommand extends ClientCommand {
  TilePosition tilePosition;
  int index;

  TakeFromInventoryCommand(this.tilePosition, this.index) : super(ClientCommandType.takeFromInventory);

  /// Creates a new [TakeFromInventoryCommand] from a JSON object.
  static TakeFromInventoryCommand fromJson(Map<dynamic, dynamic> json) => _$TakeFromInventoryCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TakeFromInventoryCommandToJson(this);
}
