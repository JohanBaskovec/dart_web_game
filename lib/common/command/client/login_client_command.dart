import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';

class LoginClientCommand extends ClientCommand {
  String username;
  String password;

  LoginClientCommand([this.username, this.password]);

  @override
  void execute(GameClient client, World world) {
    client.login(username, password, world);
    print('Executed $this');
  }

  static LoginClientCommand fromByteDataReader(ByteDataReader reader) {
    final LoginClientCommand loginCommand = LoginClientCommand();
    final int usernameLength = reader.readInt8();
    loginCommand.username = reader.readUtf16String(usernameLength);
    final int passwordLength = reader.readInt8();
    loginCommand.password = reader.readUtf16String(passwordLength);
    return loginCommand;
  }

  int get bufferSize => uint8Bytes + // type byte
            uint8Bytes + // username length byte
            (username.length * uint16Bytes) + // username bytes
            uint8Bytes + // password length byte
            (password.length * uint16Bytes); // password bytes

  @override
  ByteData toByteData() {
    final ByteDataWriter writer = ByteDataWriter(bufferSize);
    writeToByteDataWriter(writer);
    return writer.byteData;
  }

  @override
  void writeToByteDataWriter(ByteDataWriter writer) {
    writer.writeUint8(ClientCommandType.login.index);
    writer.writeUint8(username.length);
    writer.writeUtf16String(username);
    writer.writeUint8(password.length);
    writer.writeUtf16String(password);
  }

  @override
  String toString() {
    return 'LoginCommand{username: $username, password: $password}';
  }
}
