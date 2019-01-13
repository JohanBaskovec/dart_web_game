import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/command/client/build_solid_object_command.dart';
import 'package:dart_game/common/command/client/move_command.dart';
import 'package:dart_game/common/command/client/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/solid_object_building.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/ui/build_menu.dart';
import 'package:dart_game/common/ui/chat.dart';
import 'package:dart_game/common/ui/inventory_menu.dart';
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
  BuildMenu buildMenu;
  Chat chat;
  InventoryMenu inventory;

  InputManager(this._body, this._canvas, this._world, this.renderer,
      this.buildMenu, this.chat, this.inventory);

  void listen() {
    _body.onClick.listen((MouseEvent e) {
      if (e.target == _canvas) {
        canvasActive = true;
      }
    });
    _body.onKeyDown.listen((KeyboardEvent e) {
      if (canvasActive && player != null) {
        if (chat.enabled && chat.input.active) {
          chat.type(e.key);
        } else {
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
              buildMenu.enabled = !buildMenu.enabled;
              break;
          }
        }
      }
    });
    window.onResize.listen((Event e) {
      renderer.resizeWindows();
    });
    _canvas.onResize.listen((Event e) {
      renderer.resizeWindows();
    });
    _canvas.onClick.listen((MouseEvent e) {
      final CanvasPosition canvasPosition =
          renderer.getCursorPositionInCanvas(e);
      if (canClick) {
        if (buildMenu.enabled) {
          if(!buildMenu.clickAt(canvasPosition)) {
            return;
          }
        }
        if (chat.enabled) {
          if (!chat.clickAt(canvasPosition)) {
            return;
          }
        }
        if (!inventory.clickAt(canvasPosition)) {
          return;
        }
        chat.input.active = false;
        final WorldPosition mousePosition =
            renderer.getWorldPositionFromCanvasPosition(canvasPosition);
        final TilePosition tilePosition = TilePosition(
            (mousePosition.x / tileSize).floor(),
            (mousePosition.y / tileSize).floor());
        if (tilePosition.x >= 0 &&
            tilePosition.x < worldSize.x &&
            tilePosition.y >= 0 &&
            tilePosition.y < worldSize.y) {
          final object =
              _world.solidObjectColumns[tilePosition.x][tilePosition.y];
          if (object == null) {
            clickOnGround(tilePosition);
          } else {
            clickOnSolidObject(object);
          }
        }
      }
    });
    _canvas.onMouseWheel.listen((WheelEvent e) {
      renderer.increaseScale(-e.deltaY / 1000.0);
    });
  }

  void move(int x, int y) {
    final command = MoveCommand(x, y);
    webSocketClient.webSocket.send(jsonEncode(command));
  }

  void clickOnSolidObject(SolidObject object) {
    final command = UseObjectOnSolidObjectCommand(
        object.tilePosition, player.inventory.currentlyEquiped.index);
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

  void clickOnGround(TilePosition tilePosition) {
    if (buildMenu.enabled && buildMenu.selectedType != null) {
      switch (buildMenu.selectedType) {
        case SolidObjectType.woodenWall:
          if (playerCanBuild(buildMenu.selectedType, player)) {
            webSocketClient.webSocket.send(jsonEncode(
                BuildSolidObjectCommand(buildMenu.selectedType, tilePosition)));
          }
          break;
        default:
          print('Not implemented yet!');
          break;
      }
    }
  }
}
