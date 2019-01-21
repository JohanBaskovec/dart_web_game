import 'dart:convert';
import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/ui/inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/build_solid_object_command.dart';
import 'package:dart_game/common/command/client/move_command.dart';
import 'package:dart_game/common/command/client/open_inventory_command.dart';
import 'package:dart_game/common/command/client/use_object_on_solid_object_command.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';

class InputManager {
  final CanvasElement _canvas;
  final BodyElement _body;
  WebSocketClient webSocketClient;
  bool canvasActive = false;
  World _world;
  DateTime lastClickTime = DateTime.now();
  Duration minDurationBetweenAction = Duration(milliseconds: 70);
  Renderer renderer;
  final Session session;
  final ClientUiController uiController;
  bool shift = false;

  InputManager(this._body, this._canvas, this._world, this.renderer,
      this.session, this.uiController);

  void listen() {
    _body.onClick.listen((MouseEvent e) {
      if (e.target == _canvas) {
        canvasActive = true;
      }
    });
    _body.onKeyDown.listen((KeyboardEvent e) {
      if (uiController.chat.enabled && uiController.chat.input.active) {
        uiController.chat.type(e.key);
      } else {
        if (session.loggedIn) {
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
              uiController.buildMenu.toggleVisible();
              break;
            case 'c':
              uiController.cookingMenu.toggleVisible();
              break;
          }
        }
      }
      switch (e.key) {
        case 'Shift':
          shift = true;
          print('shift = $shift');
          break;
        case 'Backspace':
          e.preventDefault();
          break;
      }
    });
    _body.onKeyUp.listen((KeyboardEvent e) {
      switch (e.key) {
        case 'Shift':
          shift = false;
          print('shift = $shift');
          break;
      }
    });
    window.onResize.listen((Event e) {
      renderer.initializeUi();
    });
    _canvas.onResize.listen((Event e) {
      renderer.initializeUi();
    });
    _canvas.onContextMenu.listen((MouseEvent e) {
      e.preventDefault();
    });
    _canvas.onMouseDown.listen((MouseEvent e) {
      if (session.loggedIn == false) {
        return;
      }
      final bool isRightClick = e.button == 2;
      final CanvasPosition canvasPosition =
          renderer.getCursorPositionInCanvas(e);
      if (canClick) {
        if (renderer.cameraPosition == null) {
          return;
        }
        if (uiController.buildMenu.visible) {
          if (!uiController.buildMenu.clickAt(canvasPosition)) {
            return;
          }
        }
        if (uiController.chat.enabled) {
          if (!uiController.chat.clickAt(canvasPosition)) {
            return;
          }
        }
        if (uiController.inventory.contains(canvasPosition)) {
          if (isRightClick) {
            uiController.inventory.rightClickAt(canvasPosition);
          } else {
            uiController.inventory.clickAt(canvasPosition, shift);
          }
          return;
        }
        if (uiController.cookButton.contains(canvasPosition)) {
          if (!isRightClick) {
            uiController.cookButton.leftClick();
          }
          return;
        }
        uiController.activeInventoryWindow = null;
        for (int i = 0 ; i < uiController.inventoryMenus.length ; i++) {
          final inventory = uiController.inventoryMenus[i];
          if (inventory.contains(canvasPosition)) {
            inventory.active = true;
            uiController.activeInventoryWindow = inventory;

            if (isRightClick) {
              if (inventory.rightClick(canvasPosition)) {
                uiController.inventoryMenus.remove(inventory);
                i--;
              }
            } else if (shift) {
              inventory.shiftClick(canvasPosition, inventory);
            } else {
              inventory.leftClick(canvasPosition, inventory);
            }
            return;
          } else {
            inventory.active = false;
          }
        }
        uiController.chat.input.active = false;
        final WorldPosition mousePosition =
            renderer.getWorldPositionFromCanvasPosition(canvasPosition);
        final TilePosition tilePosition = TilePosition(
            (mousePosition.x / tileSize).floor(),
            (mousePosition.y / tileSize).floor());
        if (tilePosition.x >= 0 &&
            tilePosition.x < worldSize.x &&
            tilePosition.y >= 0 &&
            tilePosition.y < worldSize.y) {
          final objectId =
              _world.solidObjectColumns[tilePosition.x][tilePosition.y];
          if (objectId == null) {
            clickOnGround(tilePosition);
          } else {
            if (e.button == 2) {
              rightClickOnSolidObject(_world.solidObjects[objectId]);
            } else {
              clickOnSolidObject(_world.solidObjects[objectId]);
            }
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

  void rightClickOnSolidObject(SolidObject object) {
    print('Right clicking on object: $object\n');
    if (object.type == SolidObjectType.woodenChest ||
        object.type == SolidObjectType.box ||
        object.type == SolidObjectType.tree ||
        object.type == SolidObjectType.appleTree) {
      webSocketClient.sendCommand(OpenInventoryCommand(object.id));
    }
  }

  void clickOnSolidObject(SolidObject object) {
    print('Clicking on object: $object\n');
    if (!playerCanGather(session.player, _world, object.id)) {
      return;
    }
    final command = UseObjectOnSolidObjectCommand(object.id);
    webSocketClient.webSocket.send(jsonEncode(command));
  }

  bool get canClick {
    return DateTime.now()
        .subtract(minDurationBetweenAction)
        .isAfter(lastClickTime);
  }

  void clickOnGround(TilePosition tilePosition) {
    print('clickOnGround $tilePosition\n');
    if (uiController.buildMenu.visible &&
        uiController.buildMenu.selectedType != null) {
      if (playerCanBuild(_world, uiController.buildMenu.selectedType,
          session.player, tilePosition)) {
        webSocketClient.webSocket.send(jsonEncode(BuildSolidObjectCommand(
            uiController.buildMenu.selectedType, tilePosition)));
      }
    }
  }
}
