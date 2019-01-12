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
  Player _player;
  bool canvasActive = false;
  World _world;
  DateTime lastClickTime = DateTime.now();
  Duration minDurationBetweenAction = Duration(milliseconds: 70);
  Renderer renderer;

  InputManager(this._body, this._canvas, this._world, this.renderer);

  void listen() {
    _body.onClick.listen((MouseEvent e) {
      if (e.target == _canvas) {
        canvasActive = true;
      }
    });
    _body.onKeyDown.listen((KeyboardEvent e) {
      if (canvasActive && player != null) {
        switch (e.key) {
          case 'd':
            move(1, 0);
            break;
          case 'q':
            move(-1, 0);
            break;
          case 's':
            move(0, 1);
            break;
          case 'z':
            move(0, -1);
            break;
          case 'b':
            renderer.buildMenuEnabled = !renderer.buildMenuEnabled;
            break;
        }
      }
    });
    _canvas.onClick.listen((MouseEvent e) {
      if (canClick) {
        final WorldPosition mousePosition = renderer.getCursorPositionInWorld(e);
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

  void move(int x, int y){
    final command = MoveCommand(x, y, player.id);
    webSocketClient.webSocket.send(jsonEncode(command));
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
            .subtract(minDurationBetweenAction)
            .isAfter(lastClickTime);
  }

  Player get player => _player;

  set player(Player value) {
    _player = value;
    renderer.player = value;
    renderer.moveCameraToPlayerPosition(value.tilePosition);
  }

}
