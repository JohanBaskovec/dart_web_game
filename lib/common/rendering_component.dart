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
import 'package:meta/meta.dart';

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

class RenderingComponent extends GameObject implements Serializable {
  Box box;
  int entityId;
  ImageType imageType;
  RenderingConfig config;
  int bufferSize;

  Entity get entity => world.entities[entityId];

  RenderingComponent.fromType(
      {@required this.imageType,
      @required this.entityId,
      @required int x,
      @required int y,
      int id,
      World world})
      : super(world: world, id: id) {
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
    setBufferSize();
  }

  TilePosition get tilePosition {
    return TilePosition(box.left ~/ tileSize, box.top ~/ tileSize);
  }

  void setBufferSize() {
    bufferSize = uint8Bytes; // imageType
    if (config.type == RenderingComponentType.item) {
      bufferSize += int32Bytes + // x
          int32Bytes; // y
    } else {
      bufferSize += int16Bytes + // x
          int16Bytes; // y
    }
    bufferSize += uint32Bytes; // id
    bufferSize += uint32Bytes; // entityId
  }

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint8(imageType.index);
    if (config.type == RenderingComponentType.item) {
      writer.writeInt32(box.left);
      writer.writeInt32(box.top);
    } else {
      final TilePosition position = box.toTilePosition();
      writer.writeInt16(position.x);
      writer.writeInt16(position.y);
    }
    writer.writeUint32(id);
    writer.writeUint32(entityId);
  }

  static RenderingComponent fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static RenderingComponent fromByteDataReader(ByteDataReader reader) {
    final ImageType type = ImageType.values[reader.readUint8()];
    final config = defaultComponentPerType[type];
    int x;
    int y;
    if (config.type == RenderingComponentType.item) {
      x = reader.readInt32();
      y = reader.readInt32();
    } else {
      x = reader.readInt16() * tileSize;
      y = reader.readInt16() * tileSize;
    }
    return RenderingComponent.fromType(
      imageType: type,
      id: reader.readUint32(),
      x: x,
      y: y,
      entityId: reader.readUint32(),
    );
  }

  @override
  String toString() {
    return 'RenderingComponent{box: $box, entityId: $entityId, imageType: $imageType, renderingConfig: $config}';
  }
}
