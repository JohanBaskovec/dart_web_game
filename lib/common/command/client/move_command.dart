import 'dart:typed_data';

import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/server/client.dart';

class MoveCommand extends ClientCommand {
  int x;
  int y;

  MoveCommand([this.x, this.y]);

  @override
  void execute(GameClient client, World world) {
    print('Executing $this\n');
    /*
    final SolidObject player = client.session.player;
    final target =
        TilePosition(player.tilePosition.x + x, player.tilePosition.y + y);
    if (target.x < worldSize.x &&
        target.x >= 0 &&
        target.y < worldSize.y &&
        target.y >= 0 &&
        world.getObjectAt(target) == null) {
      //world.moveSolidObject(player, target);
    } else {
      print('Tried to move to tile outside of map.\n');
    }
    */
  }

  @override
  ByteData toByteData() {
    // TODO: implement toBuffer
    return null;
  }
}
