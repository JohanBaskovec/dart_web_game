import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:meta/meta.dart';

enum EntityType { ground, gatherable, player, food }

const int maxId = 0xFFFFFFF; // 28 bits, 4 bits reserved for the entity type

class Entity extends GameObject {
  EntityType type;
  int _renderingComponentId;
  int _inventoryComponentId;
  int _healthComponentId;
  int _bufferSize = uint32Bytes;
  ByteData _byteData;
  bool dirty = true;

  RenderingComponent get renderingComponent =>
      world.renderingComponents[renderingComponentId];

  void set renderingComponent(RenderingComponent value) =>
      renderingComponentId = value.id;

  Entity(
      {@required this.type,
      int renderingComponentId,
      int inventoryComponentId,
      int healthComponentId,
      int id,
      World world})
      : super(world: world, id: id) {
    _renderingComponentId = renderingComponentId;
    _inventoryComponentId = inventoryComponentId;
    _healthComponentId = healthComponentId;
    _dirty();
  }

  void _dirty() {
    _bufferSize = uint32Bytes; // id + type
    if (renderingComponentId != null) {
      _bufferSize += uint32Bytes;
    }
    if (inventoryComponentId != null) {
      _bufferSize += uint32Bytes;
    }
    if (healthComponentId != null) {
      _bufferSize += uint32Bytes;
    }
    dirty = true;
  }

  int get renderingComponentId => _renderingComponentId;

  set renderingComponentId(int value) {
    _renderingComponentId = value;
    _dirty();
  }

  int get healthComponentId => _healthComponentId;

  set healthComponentId(int value) {
    _healthComponentId = value;
    _dirty();
  }

  int get inventoryComponentId => _inventoryComponentId;

  set inventoryComponentId(int value) {
    _inventoryComponentId = value;
    _dirty();
  }

  ByteData get byteData => _byteData;

  int get bufferSize => _bufferSize;

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    assert(type.index < 16);
    assert(id < maxId);
    final int typeAndId = id | (type.index << 28);
    writer.writeUint32(typeAndId);
    switch (type) {
      case EntityType.player:
        writer.writeUint32(renderingComponentId);
        break;
      case EntityType.gatherable:
        writer.writeUint32(renderingComponentId);
        break;
      case EntityType.ground:
        writer.writeUint32(renderingComponentId);
        break;
      case EntityType.food:
        writer.writeUint32(renderingComponentId);
        break;
    }
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    if (dirty) {
      _byteData = toByteData();
      dirty = false;
    }
    writer.writeByteData(_byteData);
  }

  static Entity fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static Entity fromByteDataReader(ByteDataReader reader) {
    final int typeAndId = reader.readUint32();
    final int typeId = typeAndId >> 28;
    final int id = (typeAndId << 4) >> 4;
    assert(typeId < 16);
    assert(id < maxId);
    final Entity entity = Entity(
        id: id, type: EntityType.values[typeId]);
    switch (entity.type) {
      case EntityType.player:
        entity.renderingComponentId = reader.readUint32();
        break;
      case EntityType.gatherable:
        entity.renderingComponentId = reader.readUint32();
        break;
      case EntityType.ground:
        entity.renderingComponentId = reader.readUint32();
        break;
      case EntityType.food:
        entity.renderingComponentId = reader.readUint32();
        break;
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
