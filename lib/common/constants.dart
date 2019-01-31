import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/size.dart';

final Size worldSize = Size(10, 10);
final Box worldBox = Box(left: 0, top: 0, width: worldSize.x - 1, height: worldSize.y - 1);
const int maxPlayers = 40;
const int tileSize = 40;
final Size worldSizePx = Size(worldSize.x * tileSize, worldSize.y * tileSize);
