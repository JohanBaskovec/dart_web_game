import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/serializable.dart';

abstract class GameObject implements Serializable {
  int id;

  GameObject({this.id});

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint32(id);
  }
}