import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/serializable.dart';

class Entity extends Identifiable implements Serializable {
  int renderingComponent;
  int inventoryComponent;
  int healthComponent;

  Entity({this.renderingComponent, this.inventoryComponent,
      this.healthComponent});

  static const int bufferSize = uint32Bytes + uint32Bytes + uint32Bytes;

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint32(renderingComponent);
    writer.writeUint32(inventoryComponent);
    writer.writeUint32(healthComponent);
  }

  static Entity fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static Entity fromByteDataReader(ByteDataReader reader) {
    final Entity entity = Entity();
    entity.renderingComponent = reader.readUint32();
    entity.inventoryComponent = reader.readUint32();
    entity.healthComponent = reader.readUint32();
    return entity;
  }
}
