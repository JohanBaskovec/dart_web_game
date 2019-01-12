import 'package:dart_game/common/command/command.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class RemoveSolidObjectCommand extends Command {
  TilePosition position;

  RemoveSolidObjectCommand(this.position)
      : super(CommandType.removeSolidObject);

  /// Creates a new [RemoveSolidObjectCommand] from a JSON object.
  static RemoveSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$RemoveSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$RemoveSolidObjectCommandToJson(this);
}
