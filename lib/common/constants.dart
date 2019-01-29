import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/size.dart';

final Size worldSize = Size(300, 300);
final Box worldBox = Box(0, 0, worldSize.x - 1, worldSize.y - 1);
const int maxPlayers = 40;
const int tileSize = 40;