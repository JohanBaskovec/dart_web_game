import 'dart:typed_data';

import 'package:dart_game/common/byte_data_reader.dart';
import 'package:dart_game/common/byte_data_writer.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/client/client_command_type.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';

class LoginCommand extends ClientCommand {
  String username;
  String password;

  LoginCommand([this.username, this.password]);

  @override
  void execute(GameClient client, World world) {
    client.login(username, password, world);
    print('Executed $this');
  }

  static LoginCommand fromBuffer(ByteData bytes) {
    final LoginCommand loginCommand = LoginCommand();
    final ByteDataReader reader = ByteDataReader(bytes);
    final int usernameLength = reader.readInt8();
    loginCommand.username = reader.readUtf16String(usernameLength);
    final int passwordLength = reader.readInt8();
    loginCommand.password = reader.readUtf16String(passwordLength);
    return loginCommand;
  }

  @override
  ByteData toBuffer() {
    final ByteDataWriter bytes = ByteDataWriter(1 + // type byte
            1 + // username length byte
            (username.length * 2) + // username bytes
            1 + // password length byte
            (password.length * 2) // password bytes
        );
    bytes.writeUint8(ClientCommandType.login.index);
    bytes.writeUint8(username.length);
    bytes.writeUtf16String(username);
    bytes.writeUint8(password.length);
    bytes.writeUtf16String(password);
    return bytes.byteData;
  }

  @override
  String toString() {
    return 'LoginCommand{username: $username, password: $password}';
  }
}
