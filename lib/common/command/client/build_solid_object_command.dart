import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/server/client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'build_solid_object_command.g.dart';

@JsonSerializable(anyMap: true)
class BuildSolidObjectCommand extends ClientCommand {
  SolidObjectType objectType;
  TilePosition position;

  BuildSolidObjectCommand(this.objectType, this.position)
      : super(ClientCommandType.buildSolidObject);

  @override
  void execute(GameClient client, World world) {
    if (world.getObjectAt(position) != null) {
      print(
          'Tried to build an object but one already exists at that position!');
      return;
    }

    final SolidObject player = client.session.player;

    final Map<SoftObjectType, int> recipe = buildingRecipes[objectType];
    final int playerInventoryLength = player.inventory.items.length;
    final removeFromInventoryCommand =
        RemoveFromInventoryCommand(player.id, []);
    for (var type in recipe.keys) {
      final int quantityNeeded = recipe[type];
      int quantityOwned = 0;
      for (int i = 0; i < playerInventoryLength; i++) {
        final int itemId = player.inventory.items[i];
        final SoftObject item = world.getSoftObject(itemId);
        if (item.type == type) {
          quantityOwned++;
          removeFromInventoryCommand.idsToRemove.add(itemId);
          if (quantityOwned == quantityNeeded) {
            break;
          }
        }
      }
      if (quantityOwned < quantityNeeded) {
        print('can\'t build object, not enough resources!');
        return;
      }
    }
    removeFromInventoryCommand.execute(client.session, world, null);
    final object = SolidObject(objectType, position);
    world.addSolidObject(object);
    client.sendCommand(removeFromInventoryCommand);
  }

  /// Creates a new [BuildSolidObjectCommand] from a JSON object.
  static BuildSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$BuildSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$BuildSolidObjectCommandToJson(this);
}
