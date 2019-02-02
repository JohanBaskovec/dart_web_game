import 'dart:typed_data';

class ByteDataReader {
  ByteData byteData;
  int i = 0;

  ByteDataReader(this.byteData);

  int readUint8() {
    return byteData.getUint8(i++);
  }

  int readInt8() {
    return byteData.getInt8(i++);
  }

  int readUint16() {
    final int data = byteData.getUint16(i);
    i += 2;
    return data;
  }

  int readInt16() {
    final int data = byteData.getInt16(i);
    i += 2;
    return data;
  }

  int readUint32() {
    final int data = byteData.getUint32(i);
    i += 4;
    return data;
  }

  int readInt32() {
    final int data = byteData.getInt32(i);
    i += 4;
    return data;
  }

  int readUint64() {
    final int data = byteData.getUint64(i);
    i += 8;
    return data;
  }

  int readInt64() {
    final int data = byteData.getInt64(i);
    i += 8;
    return data;
  }

  String readUtf16String(int length) {
    final Uint16List charCodes = Uint16List(length);
    for (int k = 0; k < length; k++) {
      charCodes[k] = byteData.getInt16(i + k * 2);
    }
    i += length * 2;
    return String.fromCharCodes(charCodes);

    /*
    This is twice as fast as:
    final StringBuffer sb = StringBuffer();
    for (int k = 0; k < length; k++) {
      sb.writeCharCode(readInt16());
    }
    return sb.toString();
    */
  }

  List<T> readFixedSizeList<T>(
      T Function(ByteDataReader r) fromByteDataReader) {
    final int listSize = readUint32();
    final List<T> list = List(listSize);
    for (int i = 0; i < listSize; i++) {
      final bool isNull = readUint8() == 1;
      if (isNull) {
        list[i] = null;
      } else {
        list[i] = fromByteDataReader(this);
      }
    }
    return list;
  }

  List<T> readListWithoutNull<T>(
      T Function(ByteDataReader r) fromByteDataReader) {
    final int listSize = readUint32();
    final List<T> list = List(listSize);
    for (int i = 0; i < listSize; i++) {
      list[i] = fromByteDataReader(this);
    }
    return list;
  }
}
