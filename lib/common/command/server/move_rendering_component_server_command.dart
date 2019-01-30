import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/server_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class MoveRenderingComponentServerCommand extends ServerCommand {
  int renderingComponentId;
  int x;
  int y;

  MoveRenderingComponentServerCommand(
      {this.renderingComponentId, this.x, this.y});

  @override
  void execute(Session session, World world, [UiController uiController]) {
    print('Executed $this\n');
    world.renderingComponents[renderingComponentId].box.moveTo(x, y);
  }

  static const int bufferSize = uint8Bytes + // type
          uint32Bytes + // renderingComponentId
          int32Bytes + // x
          int32Bytes // y
      ;

  @override
  ByteData toByteData() {
    final writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint8(ServerCommandType.moveRenderingComponent.index);
    writer.writeUint32(renderingComponentId);
    writer.writeInt32(x);
    writer.writeInt32(y);
  }

  static MoveRenderingComponentServerCommand fromByteDataReader(
      ByteDataReader reader) {
    final command = MoveRenderingComponentServerCommand(
        renderingComponentId: reader.readUint32(),
        x: reader.readInt32(),
        y: reader.readUint32());
    return command;
  }

  @override
  String toString() {
    return 'MoveRenderingComponentServerCommand{renderingComponentId: $renderingComponentId, x: $x, y: $y}';
  }
}
