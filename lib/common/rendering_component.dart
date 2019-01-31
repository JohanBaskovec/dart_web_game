import 'dart:typed_data';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/serializable.dart';
import 'package:dart_game/common/tile_position.dart';

class RenderingComponent extends GameObject implements Serializable {
  Box box;
  int entityId;
  bool gridAligned;
  ImageType imageType;
  int zIndex;

  Entity get entity => world.entities[entityId];

  RenderingComponent(
      {this.box,
      this.entityId,
      this.gridAligned,
      this.imageType,
      World world,
      int id,
      this.zIndex})
      : super(world: world, id: id);

  TilePosition get tilePosition {
    return TilePosition(box.left ~/ tileSize, box.top ~/ tileSize);
  }

  static const int bufferSize = uint32Bytes + // id
          Box.bufferSize + // box
          uint32Bytes + // entityId
          uint8Bytes + // gridAligned
          uint16Bytes + // imageType
          uint8Bytes // zIndex
      ;

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    super.writeToByteDataWriter(writer);
    box.writeToByteDataWriter(writer);
    writer.writeUint32(entityId);
    writer.writeUint8(gridAligned ? 1 : 0);
    writer.writeUint16(imageType.index);
    writer.writeUint8(zIndex);
  }

  static RenderingComponent fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static RenderingComponent fromByteDataReader(ByteDataReader reader) {
    final renderingComponent = RenderingComponent(
        id: reader.readUint32(),
        box: Box.fromByteDataReader(reader),
        entityId: reader.readUint32(),
        gridAligned: reader.readUint8() == 1,
        imageType: ImageType.values[reader.readUint16()],
        zIndex: reader.readUint8());

    return renderingComponent;
  }

  @override
  String toString() {
    return 'RenderingComponent{box: $box, entityId: $entityId, gridAligned: $gridAligned}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenderingComponent &&
          runtimeType == other.runtimeType &&
          box == other.box &&
          entityId == other.entityId &&
          gridAligned == other.gridAligned;

  @override
  int get hashCode => box.hashCode ^ entityId.hashCode ^ gridAligned.hashCode;
}
