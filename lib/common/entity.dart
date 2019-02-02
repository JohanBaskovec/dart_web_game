import 'dart:typed_data';

import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:meta/meta.dart';

enum EntityType { ground, gatherable, player, food }

const int maxId = 0xFFFFFFF; // 28 bits, 4 bits reserved for the entity type
enum RenderingComponentType { ground, item, solid }

class RenderingConfig {
  RenderingComponentType type;
  int width;
  int height;

  RenderingConfig({this.type, this.width, this.height});
}

final Map<ImageType, RenderingConfig> defaultComponentPerType = {
  ImageType.apple:
      RenderingConfig(type: RenderingComponentType.item, width: 20, height: 20),
  ImageType.log:
      RenderingConfig(type: RenderingComponentType.item, width: 20, height: 20),
  ImageType.tree: RenderingConfig(type: RenderingComponentType.solid),
  ImageType.player: RenderingConfig(type: RenderingComponentType.solid),
  ImageType.grass: RenderingConfig(type: RenderingComponentType.ground),
  ImageType.dirt: RenderingConfig(type: RenderingComponentType.ground),
};

class Entity extends GameObject {
  EntityType type;
  int _inventoryComponentId;
  int _healthComponentId;
  int _bufferSize = uint32Bytes;
  ByteData _byteData;
  Box box;
  ImageType imageType;
  RenderingConfig config;
  bool dirty = true;

  Entity({
    @required this.type,
    this.imageType,
    int x,
    int y,
    int inventoryComponentId,
    int healthComponentId,
    int id,
    int areaId,
  }) : super(id: id, areaId: areaId) {
    config = defaultComponentPerType[imageType];
    if (config == null) {
      throw Exception('Not implemented!');
    }
    box = Box(
        left: x,
        top: y,
        width: config.type == RenderingComponentType.item
            ? config.width
            : tileSize,
        height: config.type == RenderingComponentType.item
            ? config.height
            : tileSize);
    _inventoryComponentId = inventoryComponentId;
    _healthComponentId = healthComponentId;
    _dirty();
  }

  TilePosition get tilePosition {
    return TilePosition(box.left ~/ tileSize, box.top ~/ tileSize);
  }

  int get healthComponentId => _healthComponentId;

  set healthComponentId(int value) {
    _healthComponentId = value;
  }

  int get inventoryComponentId => _inventoryComponentId;

  set inventoryComponentId(int value) {
    _inventoryComponentId = value;
    _dirty();
  }

  void moveTo(int x, int y) {
    box.moveTo(x, y);
    dirty = true;
  }

  ByteData get byteData => _byteData;

  int get bufferSize => _bufferSize;

  void _dirty() {
    _bufferSize = uint16Bytes + // id
        uint16Bytes + // areaId
        uint8Bytes + // type
        uint16Bytes + // imageType
        uint32Bytes + // x
        uint32Bytes; // y

    if (inventoryComponentId != null) {
      _bufferSize += uint16Bytes;
    }
    if (healthComponentId != null) {
      _bufferSize += uint16Bytes;
    }
    dirty = true;
  }

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    assert(type.index < 16);
    assert(id < maxId);
    writer.writeUint16(id);
    writer.writeUint16(areaId);
    writer.writeUint8(type.index);
    writer.writeUint16(imageType.index);
    writer.writeUint32(box.left);
    writer.writeUint32(box.top);
    switch (type) {
      case EntityType.player:
        break;
      case EntityType.gatherable:
        break;
      case EntityType.ground:
        break;
      case EntityType.food:
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
    final Entity entity = Entity(
        id: reader.readUint16(),
        areaId: reader.readUint16(),
        type: EntityType.values[reader.readUint8()],
        imageType: ImageType.values[reader.readUint16()],
        x: reader.readUint32(),
        y: reader.readUint32());
    switch (entity.type) {
      case EntityType.player:
        break;
      case EntityType.gatherable:
        break;
      case EntityType.ground:
        break;
      case EntityType.food:
        break;
    }
    return entity;
  }

  @override
  String toString() {
    return 'Entity{type: $type, _inventoryComponentId: $_inventoryComponentId, _healthComponentId: $_healthComponentId, _bufferSize: $_bufferSize, _byteData: $_byteData, box: $box, imageType: $imageType, config: $config, dirty: $dirty}';
  }

}
