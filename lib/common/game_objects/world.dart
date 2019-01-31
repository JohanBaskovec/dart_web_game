import 'dart:core';

import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';

class ObjectHolder<T extends GameObject> implements Iterable<T> {
  List<T> objects = [];
  List<int> freeObjectsId = [];
  World world;

  ObjectHolder(this.world);

  void add(T object) {
    if (freeObjectsId.isEmpty) {
      object.id = objects.length;
      objects.add(object);
    } else {
      final int id = freeObjectsId.removeLast();
      object.id = id;
      objects[id] = object;
    }
    object.world = world;
  }

  void removeAt(int index) {
    freeObjectsId.add(index);
    objects[index] = null;
  }

  void put(int index, T object) {
    objects[index] = object;
  }

  void replaceWith(List<T> objects) {
    this.objects = objects;
    for (T t in this.objects) {
      if (t != null) {
        t.world = world;
      }
    }
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

class World {
  List<List<Tile>> tiles = [];
  ObjectHolder<Entity> entities;
  ObjectHolder<RenderingComponent> renderingComponents;
  List<Message> messages = [Message('wow', 'ça marche éé à@ç£汉字;')];

  World.fromConstants() {
    entities = ObjectHolder(this);
    renderingComponents = ObjectHolder(this);
    tiles = List(worldSize.x);
    for (int x = 0; x < worldSize.x; x++) {
      tiles[x] = List(worldSize.y);
      for (int y = 0 ; y < worldSize.y ; y++) {
        tiles[x][y] = Tile();
      }
    }
  }

  Tile getTileAt(TilePosition position) {
    return tiles[position.x][position.y];
  }

  /*
  Entity getTileAt(TilePosition position) {
    return entities[tilesColumn[position.x][position.y]];
  }

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

  void removeSoftObjectId(int id) {}

  void sendCommandToAllClients(ServerCommand command) {}

  void update() {}
}
