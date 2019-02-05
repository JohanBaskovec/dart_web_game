import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/size.dart';

// width (and height) of an area in tiles
const int areaTileSize = 16;
// width (and height) of the world in areas
const int worldAreaSize = 5;
// total number of areas in the world
const int nAreas = worldAreaSize * worldAreaSize;
// width (and height) of the world in tiles
const int worldTileSize = worldAreaSize * areaTileSize;
// total number of tiles in the world
const int nTiles = worldTileSize * worldTileSize;
// bounding box of the world in tiles
final Box worldBox =
    Box(left: 0, top: 0, width: worldTileSize - 1, height: worldTileSize - 1);
const int maxPlayers = 40;
// width and height of each tile in pixel
const int tileSize = 40;
final Size worldSizePx =
    Size(worldTileSize * tileSize, worldTileSize * tileSize);
// width and height of areas in pixel
const int areaSizePx = areaTileSize * tileSize;
final Box worldBoxPx =
    Box(left: 0, top: 0, width: worldTileSize * tileSize, height: worldTileSize * tileSize);
