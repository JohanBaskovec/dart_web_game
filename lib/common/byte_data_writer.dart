import 'dart:typed_data';

import 'package:dart_game/common/serializable.dart';

const int uint64Bytes = 8;
const int int64Bytes = 8;
const int uint32Bytes = 4;
const int int32Bytes = 4;
const int uint16Bytes = 2;
const int int16Bytes = 2;
const int uint8Bytes = 1;
const int int8Bytes = 1;

class ByteDataWriter {
  ByteData byteData;
  int i = 0;

  ByteDataWriter(int size) : byteData = ByteData(size);

  void writeUint8(int data) {
    byteData.setUint8(i, data);
    i++;
  }

  void writeInt8(int data) {
    byteData.setInt8(i, data);
    i++;
  }

  void writeUint16(int data) {
    byteData.setUint16(i, data);
    i += 2;
  }

  void writeInt16(int data) {
    byteData.setInt16(i, data);
    i += 2;
  }

  void writeUint32(int data) {
    byteData.setUint32(i, data);
    i += 4;
  }

  void writeInt32(int data) {
    byteData.setInt32(i, data);
    i += 4;
  }

  void writeUint64(int data) {
    byteData.setUint64(i, data);
    i += 8;
  }

  void writeInt64(int data) {
    byteData.setInt64(i, data);
    i += 8;
  }

  void writeObject<T extends Serializable>(T data) {
    data.writeToByteDataWriter(this);
  }

  void writeList<T extends Serializable>(List<T> data) {
    writeUint32(data.length);
    for (T t in data) {
      if (t == null) {
        writeUint8(1);
      } else {
        writeUint8(0);
        t.writeToByteDataWriter(this);
      }
    }
  }

  void writeUtf16String(String data) {
    for (int codeUnit in data.codeUnits) {
      writeInt16(codeUnit);
    }
  }
}
