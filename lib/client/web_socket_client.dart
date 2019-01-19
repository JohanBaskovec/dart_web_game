import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/common/command/client/client_command.dart';
import 'package:dart_game/common/command/server/server_command.dart';
import 'package:dart_game/common/command/server/set_equipped_item_server_command.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class WebSocketClient {
  final WebSocket webSocket;
  final World _world;
  final Renderer renderer;
  final Session session;
  final UiController uiController;

  WebSocketClient(this.webSocket, this._world, this.renderer, this.session,
      this.uiController);

  void connect() {
    webSocket.onMessage.listen((MessageEvent e) {
      final ServerCommand command =
          ServerCommand.fromJson(jsonDecode(e.data as String) as Map);
      command.execute(session, _world, uiController);
    });
    webSocket.onOpen.listen((Event e) {});
  }

  void sendCommand(ClientCommand command) {
    webSocket.send(jsonEncode(command));
  }

  void executeSetEquippedCommand(SetEquippedItemServerCommand command) {
    assert(command.itemId != null);
    session.player.inventory.currentlyEquiped = command.itemId;
  }
}
