import 'dart:math';

import 'package:dart_game/client/component/rendering_component.dart';
import 'package:dart_game/client/component/usable_component.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:dart_game/common/inventory.dart';
import 'package:dart_game/common/size.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world.g.dart';

@JsonSerializable(anyMap: true)
class World {
  Size _dimension;
  List<List<Tile>> tilesColumn = [];
  List<List<int>> solidObjectColumns = [];
  List<Inventory> publicInventories = [];
  List<Inventory> privateInventories = [];
  List<TilePosition> gridPositions = [];
  List<int> freeGridPositionsIds = [];
  List<Entity> entities = [];
  List<int> freeEntityIds = [];
  List<RenderingComponent> renderingComponents = [];
  List<int> freeRenderingComponentsIds = [];
  List<UsableComponent> usableComponents = [];

  World();

  int addGridAlignedEntity(EntityType image, TilePosition position) {
    final double x = (position.x * tileSize).toDouble();
    final double y = (position.y * tileSize).toDouble();
    final Entity entity = addEntity(image);
    renderingComponents[entity.id].box =
        Box(x, y, tileSize.toDouble(), tileSize.toDouble());
    gridPositions[entity.id] = position;
    solidObjectColumns[position.x][position.y] = entityId;
    return entityId;
  }

  Entity addEntity(EntityType type) {
    int entityId;
    Entity entity;
    final bool addNewId = freeEntityIds.isEmpty;
    if (addNewId) {
      entityId = entities.length;
      entity = Entity(entityId);
      entities.add(entity);
    } else {
      entityId = freeEntityIds.removeLast();
      entity = Entity(entityId);
      entities[entityId] = entity;
    }
    addRenderingComponent(entity, RenderingComponent(type, null));
    return entity;
  }
  
  void addRenderingComponent(Entity entity, RenderingComponent renderingComponent) {
    int id;
    final bool addNewId = freeRenderingComponentsIds.isEmpty;
    if (addNewId) {
      id = renderingComponents.length;
      renderingComponents.add(renderingComponent);
    } else {
      id = freeRenderingComponentsIds.removeLast();
    }
    entity.renderingComponentId = id;
  }

  World.fromConstants(Random randomGenerator)
      : _dimension = worldSize,
        tilesColumn = List(worldSize.x),
        solidObjectColumns = List(worldSize.x) {
    for (int x = 0; x < _dimension.x; x++) {
      tilesColumn[x] = List(_dimension.y);
    }
    for (List<Tile> column in tilesColumn) {
      for (int i = 0; i < column.length; i++) {
        column[i] = Tile();
      }
    }

    for (int x = 0; x < _dimension.x; x++) {
      solidObjectColumns[x] = List(_dimension.y);
    }
    for (int x = 0; x < solidObjectColumns.length; x++) {
      for (int y = 0; y < solidObjectColumns[x].length; y++) {
        final int rand = randomGenerator.nextInt(100);
        if (rand < 10) {
          final treeId =
              addGridAlignedEntity(EntityType.tree, TilePosition(x, y));
          /*
          final int nLogs = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLogs; i++) {
            privateInventories[treeId].addItem(addEntity(EntityType.log));
          }
          usableComponents[treeId] = UsableComponent();
          final int nLeaves = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLeaves; i++) {
            tree.inventory.addItem(Entity(EntityType.leaves));
          }
          final int nSnakes = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nSnakes; i++) {
            tree.inventory.addItem(Entity(EntityType.snake));
          }
          solidObjectColumns[x][y] = tree;
          */
        } else if (rand < 20) {
          /*
          final tree = Entity(EntityType.appleTree, TilePosition(x, y));
          final int nLogs = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLogs; i++) {
            tree.inventory.addItem(Entity(EntityType.fruitTreeLog));
          }
          final int nApples = randomGenerator.nextInt(6) + 1;
          for (int i = 0; i < nLogs; i++) {
            tree.inventory.addItem(Entity(EntityType.apple));
          }
          solidObjectColumns[x][y] = tree;
          */
        }
      }
    }
  }

  /*
  Entity useItem(Entity source, Entity target) {
    final WorldPosition position = positions[target.id];
    final TilePosition tilePosition = TilePosition(
        (position.x / tileSize).floor(), (position.y / tileSize).floor());
    switch (target.type) {
      case EntityType.tree:
        if (source.type == EntityType.axe) {
          final itemFromInventory =
              privateInventories[target.id].popFirstOfType(EntityType.log);
          if (itemFromInventory != null) {
            if (itemFromInventory.itemsLeft == 0) {
              solidObjectColumns[tilePosition.x][tilePosition.y] = null;
            }
            return itemFromInventory.object;
          }
        }
        break;
      default:
        break;
    }
    return null;
  }
  */

  Size get dimension => _dimension;

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$WorldToJson(this);

  void removeEntity(int entityId) {
    tilesColumn[entityId] = null;
    solidObjectColumns[entityId] = null;
    publicInventories[entityId] = null;
    privateInventories[entityId] = null;
    gridPositions[entityId] = null;
    entities[entityId] = null;
    renderingComponents[entityId] = null;
    usableComponents[entityId] = null;
  }
}
