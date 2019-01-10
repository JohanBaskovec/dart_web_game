import 'package:dart_game_common/dart_game_common.dart';

class World {
  Size _dimension;
  List<List<Tile>> _tilesColumn;
  List<Player> _players;

  World.fromConstants()
      : _dimension = WorldSize,
        _tilesColumn = List(WorldSize.x),
        _players = List(MaxPlayers) {
    _tilesColumn.fillRange(0, _dimension.x, List(_dimension.y));
    for (List<Tile> column in _tilesColumn) {
      column.fillRange(0, _dimension.y, Tile());
    }
  }

  List<Player> get players => _players;

  List<List<Tile>> get tilesColumn => _tilesColumn;

  Size get dimension => _dimension;
}
