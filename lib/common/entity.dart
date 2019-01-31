import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/rendering_component.dart';

class Entity extends GameObject {
  int renderingComponentId;
  int inventoryComponentId;
  int healthComponentId;

  RenderingComponent get renderingComponent =>
      world.renderingComponents[renderingComponentId];

  void set renderingComponent(RenderingComponent value) =>
      renderingComponentId = value.id;

  Entity(
      {this.renderingComponentId,
      this.inventoryComponentId,
      this.healthComponentId,
      int id,
      World world})
      : super(world: world, id: id);

  int get bufferSize {
    int size = uint32Bytes; // id
    size += uint16Bytes; // component bit map
    if (renderingComponentId != 0) {
      size += uint32Bytes; // renderingComponentId
    }
    if (inventoryComponentId != 0) {
      size += uint32Bytes; // inventoryComponentId
    }
    if (healthComponentId != 0) {
      size += uint32Bytes; // healthComponentId
    }
    return size;
  }

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    // TODO: bytemap that tells which components exist on the entity,
    // that would save a lot of bandwidth
    super.writeToByteDataWriter(writer);
    int componentBitMap = 0;
    if (renderingComponentId != null) {
      componentBitMap |= 0x8000;
    }
    if (inventoryComponentId != null) {
      componentBitMap |= 0x4000;
    }
    if (healthComponentId != null) {
      componentBitMap |= 0x2000;
    }
    writer.writeUint16(componentBitMap);

    if (renderingComponentId != null) {
      writer.writeUint32(renderingComponentId);
    }
    if (inventoryComponentId != null) {
      writer.writeUint32(inventoryComponentId);
    }
    if (healthComponentId != null) {
      writer.writeUint32(healthComponentId);
    }
  }

  static Entity fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static Entity fromByteDataReader(ByteDataReader reader) {
    final Entity entity = Entity(id: reader.readUint32());
    final int componentBitMap = reader.readUint16();
    if (componentBitMap & 0x8000 != 0) {
      entity.renderingComponentId = reader.readUint32();
    }
    if (componentBitMap & 0x4000 != 0) {
      entity.inventoryComponentId = reader.readUint32();
    }
    if (componentBitMap & 0x2000 != 0) {
      entity.healthComponentId = reader.readUint32();
    }
    return entity;
  }

  @override
  String toString() {
    return 'Entity{renderingComponentId: $renderingComponentId, ${renderingComponentId != null && world != null ? 'renderingComponent: $renderingComponent' : ''}, inventoryComponentId: $inventoryComponentId, healthComponentId: $healthComponentId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity &&
          runtimeType == other.runtimeType &&
          renderingComponentId == other.renderingComponentId &&
          inventoryComponentId == other.inventoryComponentId &&
          healthComponentId == other.healthComponentId;

  @override
  int get hashCode =>
      renderingComponentId.hashCode ^
      inventoryComponentId.hashCode ^
      healthComponentId.hashCode;
}
