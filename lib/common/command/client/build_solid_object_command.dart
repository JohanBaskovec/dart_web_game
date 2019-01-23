import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/command/server/remove_from_inventory_command.dart';
import 'package:dart_game/common/constants.dart';
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
  List<int> itemIds;

  BuildSolidObjectCommand(this.objectType, this.position, this.itemIds)
      : super(ClientCommandType.buildSolidObject);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    if (position.x >= worldSize.x) {
      print('position.x larger than worldSize.x!\n');
      return;
    }
    if (position.x < 0) {
      print('position.x less than 0!\n');
      return;
    }
    if (position.y >= worldSize.y) {
      print('position.y larger than worldSize.y!\n');
      return;
    }
    if (position.y < 0) {
      print('position.y smaller than 0!\n');
      return;
    }
    if (world.getObjectAt(position) != null) {
      print('Tried to build an object but one already exists at that position!\n');
      return;
    }

    final SolidObject player = client.session.player;
    if (!player.isAdjacentToPosition(position)) {
      print('Position is too far.');
      return;
    }

    final Iterable<SoftObject> items = itemIds.map((itemId) => world.getSoftObject(itemId));
    if (!playerCanBuild(items, world, objectType, player, position)) {
      print("Can't build object. The position is too far away "
          'or not enough items.\n');
      return;
    }

    for (int itemId in itemIds) {
      if (!player.inventory.contains(itemId)) {
        print("Player inventory doesn't contain $itemId\n");
        return;
      }
    }

    double quality = 0;

    final BuildingConfiguration recipe = buildingRecipes[objectType];
    final List<SoftObject> itemsToConsume =
        consumeItemsForCrafting(client, recipe.requiredItems, items, world);

    final removeFromInventoryCommand = RemoveFromInventoryCommand(player.id, []);
    for (SoftObject item in itemsToConsume) {
      quality += item.quality;
      removeFromInventoryCommand.idsToRemove.add(item.id);
      world.removeSoftObject(item);
    }
    quality /= items.length;
    final double skill = player.playerSkills.skills[recipe.skillRequired];
    quality *= skill;

    removeFromInventoryCommand.execute(client.session, world);
    client.sendCommand(removeFromInventoryCommand);

    final object = SolidObject(quality, objectType, position);
    world.addSolidObject(object);
  }

  /// Creates a new [BuildSolidObjectCommand] from a JSON object.
  static BuildSolidObjectCommand fromJson(Map<dynamic, dynamic> json) =>
      _$BuildSolidObjectCommandFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$BuildSolidObjectCommandToJson(this);

  @override
  String toString() {
    return 'BuildSolidObjectCommand{objectType: $objectType, position: $position}';
  }
}
