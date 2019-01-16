import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'build_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class BuildSolidObjectCommand extends ClientCommand {
  SolidObjectType objectType;
  TilePosition position;

  BuildSolidObjectCommand(this.objectType, this.position)
      : super(ClientCommandType.buildSolidObject);

  /// Creates a new [BuildSolidObjectCommand] from a JSON object.
  static BuildSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$BuildSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$BuildSolidObjectCommandToJson(this);
}
