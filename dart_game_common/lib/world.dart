import 'package:dart_game_common/player.dart';
import 'package:dart_game_common/size.dart';
import 'package:dart_game_common/tile.dart';

class World {
  Size _dimension;
  List<List<Tile>> _tilesColumn;
  List<Player> _players;

  World(this._dimension): _tilesColumn = List(_dimension.x), _players = [] {
    _tilesColumn.fillRange(0, _dimension.x, List(_dimension.y));
    for (List<Tile> column in _tilesColumn) {
      column.fillRange(0, _dimension.y, Tile());
    }
  }

  List<Player> get players => _players;

  List<List<Tile>> get tilesColumn => _tilesColumn;

  Size get dimension => _dimension;
}