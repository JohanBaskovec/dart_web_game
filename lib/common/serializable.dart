import 'dart:typed_data';

abstract class Serializable {
  ByteData toBuffer();
}
