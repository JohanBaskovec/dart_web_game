import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart';
import 'package:dart_game/server/world_manager.dart';
import 'package:json_annotation/json_annotation.dart';

part 'move_command.g.dart';

@JsonSerializable(anyMap: true)
class MoveCommand extends ClientCommand {
  int x;
  int y;

  MoveCommand([this.x, this.y]): super(ClientCommandType.move);

  @override
  void execute(GameClient client, WorldManager worldManager) {
    final SolidObject player = client.session.player;
    final target = TilePosition(
        player.tilePosition.x + x, player.tilePosition.y + y);
    if (target.x < worldSize.x &&
        target.x >= 0 &&
        target.y < worldSize.y &&
        target.y >= 0 &&
        worldManager.getObjectAt(target) == null) {
      worldManager.moveSolidObject(player, target);
    }
  }

  /// Creates a new [MoveCommand] from a JSON object.
  static MoveCommand fromJson(Map<dynamic, dynamic> json) =>
      _$MoveCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MoveCommandToJson(this);
}

