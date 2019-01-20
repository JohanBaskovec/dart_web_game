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

  SoftObject addSoftObjectOfType(SoftObjectType type) {
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


  void sendCommandToAllClients(ServerCommand command) {}

  /// Creates a new [World] from a JSON object.
  static World fromJson(Map<dynamic, dynamic> json) => _$WorldFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$WorldToJson(this);
  
  void update() {
  }
}
