import 'dart:typed_data';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/serializable.dart';

class RenderingComponent extends Identifiable implements Serializable {
  Box box;
  int entityId;

  RenderingComponent(this.box, this.entityId);

  static const int bufferSize = Box.bufferSize + // box
      uint32Bytes; // entityId

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    box.writeToByteDataWriter(writer);
    writer.writeInt32(entityId);
  }

  static RenderingComponent fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static RenderingComponent fromByteDataReader(ByteDataReader reader) {
    final renderingComponent =
        RenderingComponent(Box.fromByteDataReader(reader), reader.readUint32());

    return renderingComponent;
  }
}
