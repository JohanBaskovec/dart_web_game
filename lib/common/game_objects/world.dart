import 'dart:core';

import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';

List<List<Tile>> tiles = [];

List<Message> messages = [Message('wow', 'ça marche éé à@ç£汉字;')];

void init() {
  tiles = List(worldTileSize);
  for (int x = 0; x < worldTileSize; x++) {
    tiles[x] = List(worldTileSize);
    for (int y = 0; y < worldTileSize; y++) {
      tiles[x][y] = Tile();
    }
  }
}

int getAreaIndex(int x, int y) {
  final int tileX = x ~/ tileSize;
  final int tileY = y ~/ tileSize;
  return (tileX / areaTileSize).floor() +
      (tileY / areaTileSize).floor() * (worldTileSize / areaTileSize).floor();
}

List<List<Entity>> getSurroundingRenderingComponentList(
    int x, int y) {
  final List<List<Entity>> entities = List(9);
  entities[0] = getEntityInArea(x, y);
  entities[1] = getEntityInArea(x - areaSizePx, y);
  entities[2] = getEntityInArea(x + areaSizePx, y);
  entities[3] = getEntityInArea(x, y - areaSizePx);
  entities[4] = getEntityInArea(x, y + areaSizePx);
  entities[5] = getEntityInArea(x + areaSizePx, y + areaSizePx);
  entities[6] = getEntityInArea(x - areaSizePx, y - areaSizePx);
  entities[7] = getEntityInArea(x + areaSizePx, y - areaSizePx);
  entities[8] = getEntityInArea(x - areaSizePx, y + areaSizePx);
  return entities;
}

class EntityHolder {
  List<List<Entity>> objects = List(nAreas);

  EntityHolder() {
    for (int i = 0; i < objects.length; i++) {
      objects[i] = [];
    }
  }

  void add(Entity object) {
    final int areaIndex = getAreaIndex(object.box.left, object.box.top);
    addToArea(object, areaIndex);
  }

  void addToArea(Entity object, int areaIndex) {
    final List<Entity> entities = objects[areaIndex];
    object.id = entities.length;
    entities.add(object);
    object.areaId = areaIndex;
  }

  void remove(Entity object) {
    objects[object.areaId].removeAt(object.id);
  }

  int get length => objects.length;

  List<Entity> operator [](int index) => objects[index];
}

final EntityHolder entities = EntityHolder();

List<Entity> getEntityInArea(int x, int y) {
  final int areaIndex = getAreaIndex(x, y);
  if (areaIndex >= 0 && areaIndex < entities.length) {
    return entities[areaIndex];
  } else {
    return null;
  }
}

Tile getTileAt(TilePosition position) {
  return tiles[position.x][position.y];
}

void update() {}
