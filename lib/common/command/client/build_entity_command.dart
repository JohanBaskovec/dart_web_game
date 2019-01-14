import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'build_entity_command.g.dart';

@JsonSerializable(anyMap: true)
class BuildEntityCommand extends ClientCommand {
  TilePosition position;
  EntityType entityType;

  BuildEntityCommand(this.entityType, this.position)
      : super(ClientCommandType.buildEntity);

  /// Creates a new [BuildEntityCommand] from a JSON object.
  static BuildEntityCommand fromJson(Map<dynamic, dynamic> json) =>
      _$BuildEntityCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$BuildEntityCommandToJson(this);
}
