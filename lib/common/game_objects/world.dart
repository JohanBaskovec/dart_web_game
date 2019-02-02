import 'dart:core';

import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';

List<List<Tile>> tiles = [];
ObjectHolder<Entity> entities;

ObjectHolder<RenderingComponent> renderingComponents;
List<ObjectHolder<RenderingComponent>> renderingComponentsByArea =
    List((worldSize / areaSize).floor() * (worldSize / areaSize).floor());
List<Message> messages = [Message('wow', 'ça marche éé à@ç£汉字;')];

class ObjectHolder<T extends GameObject> implements Iterable<T> {
  List<T> objects = [];
  int nNotNull = 0;
  List<int> freeObjectsId = [];
  int maxObjects;

  ObjectHolder(this.maxObjects);

  void add(T object) {
    assert(object != null);
    if (object.id == null) {
      if (freeObjectsId.isEmpty) {
        object.id = objects.length;
        objects.add(object);
      } else {
        final int id = freeObjectsId.removeLast();
        object.id = id;
        objects[id] = object;
      }
    } else {
      if (object.id >= maxObjects) {
        throw Exception('Out of memory!');
      }
      if (object.id >= objects.length) {
        final int diff = object.id - objects.length;
        for (int i = objects.length; i < object.id; i++) {
          freeObjectsId.add(i);
        }
        objects.length = object.id + 1;
      }
      if (objects[object.id] == null) {
        nNotNull++;
      }
      objects[object.id] = object;
    }
    nNotNull++;
  }

  void remove(T object) {
    removeAt(object.id);
  }

  void removeAt(int index) {
    freeObjectsId.add(index);
    objects[index] = null;
    nNotNull--;
  }

  T operator [](int index) => objects[index];

  @override
  int get length => objects.length;

  @override
  bool any(bool Function(T element) test) {
    return objects.any(test);
  }

  @override
  Iterable<R> cast<R>() {
    return objects.cast();
  }

  @override
  bool contains(Object element) {
    return objects.contains(element);
  }

  @override
  T elementAt(int index) {
    return objects.elementAt(index);
  }

  @override
  bool every(bool Function(T element) test) {
    return objects.every(test);
  }

  @override
  // TODO: implement first
  T get first => objects.first;

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) {
    return objects.firstWhere(test, orElse: orElse);
  }

  @override
  U fold<U>(U initialValue, U Function(U previousValue, T element) combine) {
    return objects.fold(initialValue, combine);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return objects.followedBy(other);
  }

  @override
  void forEach(void Function(T element) f) {
    return objects.forEach(f);
  }

  @override
  bool get isEmpty => objects.isEmpty;

  @override
  bool get isNotEmpty => objects.isNotEmpty;

  @override
  Iterator<T> get iterator => objects.iterator;

  @override
  String join([String separator = '']) {
    return objects.join(separator);
  }

  @override
  T get last => objects.last;

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) {
    return objects.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<U> map<U>(U Function(T e) f) {
    return objects.map(f);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    return objects.reduce(combine);
  }

  @override
  T get single => objects.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) {
    return objects.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    return objects.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    return objects.skipWhile(test);
  }

  @override
  Iterable<T> take(int count) {
    return objects.take(count);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    return objects.takeWhile(test);
  }

  @override
  List<T> toList({bool growable = true}) {
    return objects.toList(growable: growable);
  }

  @override
  Set<T> toSet() {
    return objects.toSet();
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return objects.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return objects.whereType<T>();
  }

  @override
  Iterable<U> expand<U>(Iterable<U> Function(T element) f) {
    return objects.expand(f);
  }
}

void init() {
  entities = ObjectHolder(200000);
  renderingComponents = ObjectHolder(200000);
  for (int i = 0; i < renderingComponentsByArea.length; i++) {
    renderingComponentsByArea[i] = ObjectHolder(200000);
  }
  tiles = List(worldSize);
  for (int x = 0; x < worldSize; x++) {
    tiles[x] = List(worldSize);
    for (int y = 0; y < worldSize; y++) {
      tiles[x][y] = Tile();
    }
  }
}

int getAreaIndex(int x, int y) {
  final int tileX = x ~/ tileSize;
  final int tileY = y ~/ tileSize;
  return (tileX / areaSize).floor() +
      (tileY / areaSize).floor() * (worldSize / areaSize).floor();
}

List<List<RenderingComponent>> getSurroundingRenderingComponentList(
    int x, int y) {
  final List<List<RenderingComponent>> renderings = List(9);
  renderings[0] = getRenderingComponentsList(x, y);
  renderings[1] = getRenderingComponentsList(x - areaSizePx, y);
  renderings[2] = getRenderingComponentsList(x + areaSizePx, y);
  renderings[3] = getRenderingComponentsList(x, y - areaSizePx);
  renderings[4] = getRenderingComponentsList(x, y + areaSizePx);
  renderings[5] = getRenderingComponentsList(x + areaSizePx, y + areaSizePx);
  renderings[6] = getRenderingComponentsList(x - areaSizePx, y - areaSizePx);
  renderings[7] = getRenderingComponentsList(x + areaSizePx, y - areaSizePx);
  renderings[8] = getRenderingComponentsList(x - areaSizePx, y + areaSizePx);
  return renderings;
}

List<RenderingComponent> getRenderingComponentsList(int x, int y) {
  final int areaIndex = getAreaIndex(x, y);
  if (areaIndex >= 0 && areaIndex < renderingComponentsByArea.length) {
    return renderingComponentsByArea[areaIndex].objects;
  } else {
    return null;
  }
}

Tile getTileAt(TilePosition position) {
  return tiles[position.x][position.y];
}

void addRenderingComponent(RenderingComponent rendering) {
  renderingComponents.add(rendering);
  final int areaIndex = getAreaIndex(rendering.box.left, rendering.box.top);
  renderingComponentsByArea[areaIndex].add(rendering);
}
/*
  List<Tile> getTileAround(TilePosition position) {
    final List<Tile> tiles = [];
    final Box box = Box(position.x - 1, position.y - 1, 2, 2);
    box.clamp(worldBox);
    for (int x = box.left; x <= box.right; x++) {
      for (int y = box.top; y <= box.bottom; y++) {
        tiles.add(tilesColumn[x][y]);
      }
    }
    return tiles;
  }
  */

void update() {}
