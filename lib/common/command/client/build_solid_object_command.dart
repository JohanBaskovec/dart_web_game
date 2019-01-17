import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:dart_game/server/game_server.dart';
import 'package:dart_game/server/world_manager.dart';
import 'package:json_annotation/json_annotation.dart';

part 'build_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class BuildSolidObjectCommand extends ClientCommand {
  SolidObjectType objectType;
  TilePosition position;

  BuildSolidObjectCommand(this.objectType, this.position)
      : super(ClientCommandType.buildSolidObject);

  @override
  void execute(GameClient client, WorldManager worldManager) {
    if (worldManager.getObjectAt(position) != null) {
      print(
          'Tried to build an object but one already exists at that position!');
      return;
    }

    final SolidObject player = client.session.player;

    final Map<SoftObjectType, int> recipe = buildingRecipes[objectType];
    final int playerInventoryLength = player.inventory.stacks.length;
    final removeFromInventoryCommand = RemoveFromInventoryCommand(
        player.id, List.filled(playerInventoryLength, 0));
    for (var type in recipe.keys) {
      final int quantity = recipe[type];
      for (int i = 0; i < playerInventoryLength; i++) {
        if (player.inventory.stacks[i].objectType == type) {
          if (player.inventory.stacks[i].length >= quantity) {
            removeFromInventoryCommand.nObjectsToRemoveFromEachStack[i] =
                quantity;
          } else {
            print('can\'t build object, not enough resources!');
            return;
          }
          break;
        }
      }
    }
    removeFromInventoryCommand.execute(worldManager.world);
    final object = SolidObject(objectType, position);
    worldManager.addSolidObject(object);
    client.sendCommand(removeFromInventoryCommand);
  }

  /// Creates a new [BuildSolidObjectCommand] from a JSON object.
  static BuildSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$BuildSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$BuildSolidObjectCommandToJson(this);
}
