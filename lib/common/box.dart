import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/serializable.dart';

class Box implements Serializable {
  int left;
  int right;
  int top;
  int bottom;
  int width;
  int height;

  Box({this.left, this.top, this.width, this.height})
      : right = left + width,
        bottom = top + height;

  bool pointIsInBox(double x, double y) {
    return x >= left && x <= right && y >= top && y <= bottom;
  }

  void move(int x, int y) {
    left += x;
    top += y;
    right = left + width;
    bottom = top + height;
  }

  void moveTo(int x, int y) {
    left = x;
    top = y;
    right = x + width;
    bottom = y + height;
  }

  void clamp(Box worldBox) {
    if (left < worldBox.left) {
      left = worldBox.left;
    }
    if (right > worldBox.right) {
      right = worldBox.right;
    }
    if (top < worldBox.top) {
      top = worldBox.top;
    }
    if (bottom > worldBox.bottom) {
      bottom = worldBox.bottom;
    }
    width = right - left;
    height = bottom - top;
  }

  static const int bufferSize = int32Bytes + // left
      int32Bytes + // top
      uint16Bytes + // width
      uint16Bytes; // height

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeInt32(left);
    writer.writeInt32(top);
    writer.writeUint16(width);
    writer.writeUint16(height);
  }

  static Box fromByteData(ByteData data) {
    final reader = ByteDataReader(data);
    return fromByteDataReader(reader);
  }

  static Box fromByteDataReader(ByteDataReader reader) {
    final box = Box(
        left: reader.readInt32(),
        top: reader.readInt32(),
        width: reader.readUint16(),
        height: reader.readUint16());
    return box;
  }

  @override
  String toString() {
    return 'Box{left: $left, right: $right, top: $top, bottom: $bottom, width: $width, height: $height}';
  }
}
