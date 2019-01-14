import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_object_on_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class UseObjectOnEntityCommand extends ClientCommand {
  /// Position of the target object
  TilePosition targetPosition;

  /// Item index in the player's inventory
  int itemIndex;

  UseObjectOnEntityCommand(
      this.targetPosition, this.itemIndex)
      : super(ClientCommandType.useObjectOnEntity);

  /// Creates a new [UseObjectOnEntityCommand] from a JSON object.
  static UseObjectOnEntityCommand fromJson(Map<dynamic, dynamic> json) =>
      _$UseObjectOnEntityCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$UseObjectOnEntityCommandToJson(this);
}
