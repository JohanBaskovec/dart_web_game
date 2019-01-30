import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/serializable.dart';

abstract class GameObject implements Serializable {
  World world;
  int id;

  GameObject({this.id, this.world});

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint32(id);
  }
}