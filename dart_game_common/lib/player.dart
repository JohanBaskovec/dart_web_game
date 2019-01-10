import 'package:dart_game_common/tile_position.dart';

class Player {
  String _name;
  TilePosition position;
  int _id;

  Player([this._name, this._id]): position = TilePosition(0, 0);

  int get id => _id;

  String get name => _name;
}