import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/common/tile_position.dart';

class WorldPosition implements Serializable {
  int x;
  int y;

  WorldPosition([this.x, this.y]);

  TilePosition toTilePosition() {
    return TilePosition(x ~/ tileSize, y ~/ tileSize);
  }

  static const int bufferSize = int32Bytes * 2;

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeInt32(x);
    writer.writeInt32(y);
  }

  static WorldPosition fromByteDataReader(ByteDataReader reader) {
    return WorldPosition(reader.readInt32(), reader.readInt32());
  }

  bool get isInWorldBound =>
      x >= 0 && x < worldSizePx.x && y >= 0 && y < worldSizePx.y;
}
