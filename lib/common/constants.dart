import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/size.dart';

const int areaSize = 16;
const int worldSize = areaSize * 8;
final Box worldBox = Box(left: 0, top: 0, width: worldSize - 1, height: worldSize - 1);
const int maxPlayers = 40;
const int tileSize = 40;
final Size worldSizePx = Size(worldSize * tileSize, worldSize * tileSize);
const int areaSizePx = areaSize * tileSize;
