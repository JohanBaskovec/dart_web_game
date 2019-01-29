import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/tile_position.dart';

class ObjectHolder<T extends Identifiable> {
  List<T> objects = [];
  List<int> freeObjectsId = [];

  void add(T object) {
    if (freeObjectsId.isEmpty) {
      object.id = objects.length;
      objects.add(object);
    } else {
      final int id = freeObjectsId.removeLast();
      object.id = id;
      objects[id] = object;
    }
  }

  void removeAt(int index) {
    freeObjectsId.add(index);
    objects[index] = null;
  }

  void put(int index, T object) {
    objects[index] = object;
  }

  T operator [](int index) => objects[index];
}

class World {
  //List<List<int>> tileColumns = [];
  List<List<int>> solidObjectColumns = [];
  ObjectHolder<Entity> entities = ObjectHolder();
  ObjectHolder<RenderingComponent> renderingComponents = ObjectHolder();
  List<Message> messages = [Message('wow', 'ça marche éé à@ç£汉字;')];

  Entity getObjectAt(TilePosition position) {
    if (solidObjectColumns[position.x][position.y] == null) {
      return null;
    }
    return entities[solidObjectColumns[position.x][position.y]];
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
