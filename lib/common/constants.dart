import 'package:dart_game/common/size.dart';

const int maxPlayers = 40;
const int tileSize = 40;
final Size worldSizeTile = Size(10, 10);
final Size worldSizePx =
    Size(worldSizeTile.x * tileSize, worldSizeTile.x * tileSize);
