import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/component/collision_component.dart';
import 'package:dart_game/common/component/rendering_component.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_grid_aligned_entity_command.g.dart';

@JsonSerializable(anyMap: true)
class AddGridAlignedEntityCommand extends ServerCommand {
  Entity entity;
  CollisionComponent collisionComponent;
  RenderingComponent renderingComponent;

  AddGridAlignedEntityCommand(
      this.entity, this.collisionComponent, this.renderingComponent)
      : super(ServerCommandType.addGridAlignedEntity);

  /// Creates a new [AddGridAlignedEntityCommand] from a JSON object.
  static AddGridAlignedEntityCommand fromJson(Map<dynamic, dynamic> json) =>
      _$AddGridAlignedEntityCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$AddGridAlignedEntityCommandToJson(this);
}
