import 'dart:typed_data';

import 'package:dart_game/common/byte_data_writer.dart';

abstract class Serializable {
  ByteData toByteData();

  void writeToByteDataWriter(ByteDataWriter writer);
}
