import 'package:dart_game_common/dart_game_common.dart';

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
    for (List<Tile> column in _solidObjectColumns) {
      for (int i = 0 ; i < column.length ; i++) {
        column[i] = Tile();
      }
    }

  }

  List<Player> get players => _players;

  List<List<Tile>> get tilesColumn => _tilesColumn;

  Size get dimension => _dimension;
}
