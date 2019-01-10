import 'package:dart_game/constants.dart';
import 'package:dart_game/game_objects/game_object.dart';
import 'package:dart_game/player.dart';
import 'package:dart_game/size.dart';
import 'package:dart_game/tile.dart';

class World {
  Size _dimension;
  List<List<Tile>> _tilesColumn;
  List<List<GameObject>> _solidObjectColumns;
  List<Player> _players;

  World.fromConstants()
      : _dimension = WorldSize,
        _tilesColumn = List(WorldSize.x),
        _solidObjectColumns = List(WorldSize.x),
        _players = List(MaxPlayers) {
    _tilesColumn.fillRange(0, _dimension.x, List(_dimension.y));
    for (List<Tile> column in _tilesColumn) {
      for (int i = 0 ; i < column.length ; i++) {
        column[i] = Tile();
      }
    }

    _solidObjectColumns.fillRange(0, _dimension.x, List(_dimension.y));
    for (List<GameObject> column in _solidObjectColumns) {
      for (int i = 0 ; i < column.length ; i++) {
        column[i] = null;
      }
    }

  }

  List<Player> get players => _players;

  List<List<Tile>> get tilesColumn => _tilesColumn;

  Size get dimension => _dimension;
}
