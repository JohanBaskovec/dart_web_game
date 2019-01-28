import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/message.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'world.g.dart';

@JsonSerializable(anyMap: true)
class World {
  List<List<Tile>> tilesColumn = [];
  List<List<int>> solidObjectColumns = [];
  List<SolidObject> solidObjects = List(worldSize.x * worldSize.y);
  List<SoftObject> softObjects = [];
  List<int> freeSolidObjectIds = [];
  List<int> freeSoftObjectIds = [];
  List<Message> messages = [Message('wow', 'ça marche éé à@ç£汉字;')];

  void addSolidObject(SolidObject object) {}

  void removeSolidObjectAndSynchronizeAllClients(SolidObject object) {}

  SoftObject addSoftObjectOfType(double quality, SoftObjectType type) {
    return null;
  }

  Tile addTileOfType(TileType type, int x, int y) {
    return null;
  }

  void addSoftObject(SoftObject object) {}

  void moveSolidObject(SolidObject object, TilePosition position) {}

  void removeSoftObject(SoftObject object) {}

  void removeSolidObject(SolidObject object) {}

  SolidObject getObjectAt(TilePosition position) {
    if (solidObjectColumns[position.x][position.y] == null) {
      return null;
    }
    return solidObjects[solidObjectColumns[position.x][position.y]];
  }

  SolidObject getSolidObject(int id) {
    return solidObjects[id];
  }

  SoftObject getSoftObject(int id) {
    return softObjects[id];
  }

  Tile getTileAt(TilePosition position) {
    return tilesColumn[position.x][position.y];
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

  List<SoftObject> getSoftObjects(Iterable<int> ids) {
    return ids.map((itemId) => softObjects[itemId]).toList();
  }

  void removeSoftObjectId(int id) {

  }

  void sendCommandToAllClients(ServerCommand command) {}

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$WorldToJson(this);

  void update() {}
}
