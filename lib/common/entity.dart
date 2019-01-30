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
      : super(world: world, id: id) {
    renderingComponentId ??= 0;
    inventoryComponentId ??= 0;
    healthComponentId ??= 0;
  }

  static const int bufferSize = uint32Bytes + // id
      uint32Bytes + // renderingComponentId
      uint32Bytes + // inventoryComponentId
      uint32Bytes; // healthComponentId

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
    writer.writeUint32(renderingComponentId);
    writer.writeUint32(inventoryComponentId);
    writer.writeUint32(healthComponentId);
  }

  static Entity fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static Entity fromByteDataReader(ByteDataReader reader) {
    final Entity entity = Entity(
      id: reader.readUint32(),
      renderingComponentId: reader.readUint32(),
      inventoryComponentId: reader.readUint32(),
      healthComponentId: reader.readUint32(),
    );
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
