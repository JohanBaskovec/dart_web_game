import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'use_object_on_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class UseObjectOnSolidObjectCommand extends Command {
  /// Position of the target object
  TilePosition targetPosition;

  /// Id of the player (his posisition in the players list)
  int playerId;

  /// Item index in the player's inventory
  int itemIndex;

  UseObjectOnSolidObjectCommand(
      this.targetPosition, this.playerId, this.itemIndex)
      : super(CommandType.useObjectOnSolidObject);

  /// Creates a new [UseObjectOnSolidObjectCommand] from a JSON object.
  static UseObjectOnSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$UseObjectOnSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$UseObjectOnSolidObjectCommandToJson(this);
}
