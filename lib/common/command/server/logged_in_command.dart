import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/component/clickable_component.dart';
import 'package:dart_game/common/component/collision_component.dart';
import 'package:dart_game/common/component/rendering_component.dart';
import 'package:dart_game/common/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logged_in_command.g.dart';

@JsonSerializable(anyMap: true)
class LoggedInCommand extends ServerCommand {
  int playerId;
  List<RenderingComponent> renderingComponents;
  List<CollisionComponent> collisionComponents;
  List<Entity> entities;
  List<ClickableComponent> clickableComponents;

  LoggedInCommand([this.playerId, this.renderingComponents, this.collisionComponents, this.entities])
      : super(ServerCommandType.loggedIn);

  /// Creates a new [LoggedInCommand] from a JSON object.
  static LoggedInCommand fromJson(Map<dynamic, dynamic> json) =>
      _$LoggedInCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$LoggedInCommandToJson(this);
}
