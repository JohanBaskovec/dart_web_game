import 'dart:math';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/server/move_rendering_and_collision_components_command.dart';
import 'package:dart_game/common/component/clickable_component.dart';
import 'package:dart_game/common/component/collision_component.dart';
import 'package:dart_game/common/component/rendering_component.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:dart_game/common/size.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world.g.dart';

@JsonSerializable(anyMap: true)
class World {
  Size _dimension;

  // this is awful, we should use a generic class to contains all this,
  // but we can't JSON serialize/deserialize generic classes

  List<RenderingComponent> renderingComponents = [];
  List<int> renderingComponentFreeIds = [];

  List<CollisionComponent> collisionComponents = [];
  List<int> collisionComponentFreeIds = [];

  List<ClickableComponent> clickableComponents = [];
  List<int> clickableComponentFreeIds = [];

  List<Entity> entities = [];
  List<int> entitiesFreeIds = [];

  World();

  Entity addTree(TilePosition position) {
    final Entity tree = addGridAlignedEntity(EntityType.tree, position);

    return tree;
  }

  Entity addGridAlignedEntity(EntityType image, TilePosition position) {
    final int x = position.x * tileSize;
    final int y = position.y * tileSize;
    final Entity entity = createAndAddEntity(image);
    final Box box = Box(x, y, tileSize, tileSize, 1);
    final renderingComponent = RenderingComponent(image, box);
    addRenderingComponent(entity, renderingComponent);
    final collisionComponent = CollisionComponent(box);
    addCollisionComponent(entity, collisionComponent);
    addClickableComponent(entity, ClickableComponent(box));
    return entity;
  }

  /// Set entity at its id. Should only be called by the client.
  void setEntity(Entity entity) {
    if (entities.length < entity.id + 1) {
      entities.length = entity.id + 1;
    }
    entities[entity.id] = entity;
  }

  /// Set component at its id. Should only be called by the client.
  void setRenderingComponent(RenderingComponent component) {
    if (renderingComponents.length < component.id + 1) {
      renderingComponents.length = component.id + 1;
    }
    renderingComponents[component.id] = component;
  }

  void setCollisionComponent(CollisionComponent component) {
    if (collisionComponents.length < component.id + 1) {
      collisionComponents.length = component.id + 1;
    }
    collisionComponents[component.id] = component;
  }

  void setClickableComponent(ClickableComponent component) {
    if (clickableComponents.length < component.id + 1) {
      clickableComponents.length = component.id + 1;
    }
    clickableComponents[component.id] = component;
  }

  Entity createAndAddEntity(EntityType type) {
    Entity entity;
    if (entitiesFreeIds.isEmpty) {
      final int id = entities.length;
      entity = Entity(id, type);
      entities.add(entity);
    } else {
      final int id = entitiesFreeIds.removeLast();
      entity = Entity(id, type);
      entities[id] = entity;
    }
    return entity;
  }

  void addRenderingComponent(
      Entity entity, RenderingComponent renderingComponent) {
    final int id = addComponent(
        renderingComponents, renderingComponent, renderingComponentFreeIds);
    renderingComponent.id = id;
    entity.renderingComponentId = id;
  }

  void removeRenderingComponent(Entity entity) {
    assert(renderingComponents.isNotEmpty);
    removeComponent(entity.renderingComponentId, renderingComponents,
        renderingComponentFreeIds);
    entity.renderingComponentId = null;
  }

  void addCollisionComponent(Entity entity, CollisionComponent component) {
    final int id =
        addComponent(collisionComponents, component, collisionComponentFreeIds);
    component.id = id;
    entity.collisionComponentId = id;
  }

  void removeCollisionComponent(Entity entity) {
    assert(collisionComponents.isNotEmpty);
    removeComponent(entity.collisionComponentId, collisionComponents,
        collisionComponentFreeIds);
    entity.collisionComponentId = null;
  }

  void addClickableComponent(Entity entity, ClickableComponent component) {
    final int id =
        addComponent(clickableComponents, component, clickableComponentFreeIds);
    component.id = id;
    entity.clickableComponentId = id;
  }

  void removeClickableComponent(Entity entity) {
    assert(clickableComponents.isNotEmpty);
    removeComponent(entity.collisionComponentId, collisionComponents,
        collisionComponentFreeIds);
    entity.collisionComponentId = null;
  }

  void removeComponent<T>(int id, List<T> list, List<int> freeIds) {
    if (id != null) {
      list[id] = null;
      freeIds.add(id);
    }
  }

  int addComponent<T>(List<T> list, T component, List<int> freeIds) {
    int id;
    if (freeIds.isEmpty) {
      id = list.length;
      list.add(component);
    } else {
      id = freeIds.removeLast();
      list[id] = component;
    }
    return id;
  }

  World.fromConstants(Random randomGenerator) : _dimension = worldSizeTile {
    /*
    for (int x = 0; x < _dimension.x; x++) {
      tilesColumn[x] = List(_dimension.y);
    }
    for (List<Tile> column in tilesColumn) {
      for (int i = 0; i < column.length; i++) {
        column[i] = Tile();
      }
    }

    for (int x = 0; x < _dimension.x; x++) {
      for (int y = 0; y < _dimension.y; y++) {
        addEntity(type)
      }
    }
    */
    for (int x = 0; x < _dimension.x; x++) {
      for (int y = 0; y < _dimension.y; y++) {
        final int rand = randomGenerator.nextInt(100);
        if (rand < 10) {
          addTree(TilePosition(x, y));
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

  void removeEntity(Entity entity) {
    removeRenderingComponent(entity);
    removeCollisionComponent(entity);
    entities[entity.id] = null;
  }

  void executeMoveGridAlignedEntity(
      MoveRenderingAndCollisionComponentsCommand command) {
    renderingComponents[command.renderingComponentId]
        .box
        .moveTo(command.destination.x, command.destination.y);
    collisionComponents[command.collisionComponentId]
        .box
        .moveTo(command.destination.x, command.destination.y);
  }

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$WorldToJson(this);
}
