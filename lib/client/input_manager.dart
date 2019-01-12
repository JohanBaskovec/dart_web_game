import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/command/move_command.dart';
import 'package:dart_game/common/command/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/game_objects/axe.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/game_objects/tree.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/world_position.dart';

class InputManager {
  final CanvasElement _canvas;
  final BodyElement _body;
  WebSocketClient webSocketClient;
  Player player;
  bool canvasActive = false;
  World _world;
  DateTime lastClickTime = DateTime.now();
  Duration minDurationBetweenClick = Duration(milliseconds: 100);
  Renderer renderer;

  InputManager(this._body, this._canvas, this._world, this.renderer);

  CanvasPosition getCursorPositionInCanvas(MouseEvent event) {
    final rect = _canvas.getBoundingClientRect();
    final int x = event.client.x - rect.left;
    final int y = event.client.y - rect.top;
    return CanvasPosition(x, y);
  }

  WorldPosition getWorldPositionFromCanvasPosition(CanvasPosition position) {
    // TODO: once we add camera movement, we need to convert
    // the position in the world
    return WorldPosition(position.x, position.y);
  }

  WorldPosition getCursorPositionInWorld(MouseEvent event) {
    final CanvasPosition canvasPosition = getCursorPositionInCanvas(event);
    return getWorldPositionFromCanvasPosition(canvasPosition);
  }

  void listen() {
    _body.onClick.listen((MouseEvent e) {
      if (e.target == _canvas) {
        canvasActive = true;
      }
    });
    _body.onKeyUp.listen((KeyboardEvent e) {
      if (canvasActive && player != null) {
        switch (e.key) {
          case 'd':
            final command = MoveCommand(1, 0, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
          case 'q':
            final command = MoveCommand(-1, 0, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
          case 's':
            final command = MoveCommand(0, 1, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
          case 'z':
            final command = MoveCommand(0, -1, player.id);
            webSocketClient.webSocket.send(jsonEncode(command));
            break;
        }
      }
    });
    _canvas.onClick.listen((MouseEvent e) {
      if (canClick) {
        final WorldPosition mousePosition = getCursorPositionInWorld(e);
        for (List<SolidGameObject> column in _world.solidObjectColumns) {
          for (SolidGameObject object in column) {
            if (object != null) {
              maybeClickOnObject(object, mousePosition);
            }
          }
        }
        lastClickTime = DateTime.now();
      }
    });
    _canvas.onMouseWheel.listen((WheelEvent e) {
      renderer.increaseScale(-e.deltaY / 1000.0);
    });
  }

  void maybeClickOnObject(SolidGameObject object, WorldPosition position) {
    if (object.box.pointIsInBox(position)) {
      switch (object.type) {
        case SolidGameObjectType.tree:
          clickOnTree(object as Tree);
          break;
        case SolidGameObjectType.player:
        case SolidGameObjectType.appleTree:
        case SolidGameObjectType.barkTree:
        case SolidGameObjectType.ropeTree:
        case SolidGameObjectType.coconutTree:
        case SolidGameObjectType.leafTree:
          break;
      }
    }
  }

  void clickOnTree(Tree tree) {
    if (player.inventory.currentlyEquiped is Axe) {
      cutTree(player.inventory.currentlyEquiped as Axe, tree);
    }
  }

  void cutTree(Axe axe, Tree tree) {
    final command =
        UseObjectOnSolidObjectCommand(tree.tilePosition, player.id, axe.index);
    webSocketClient.webSocket.send(jsonEncode(command));
  }

  bool get canClick {
    return DateTime.now()
            .subtract(minDurationBetweenClick)
            .isAfter(lastClickTime);
  }
}
