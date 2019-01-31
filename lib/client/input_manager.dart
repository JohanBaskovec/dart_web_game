import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/renderer.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/command/client/move_client_command.dart';
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
  bool mouseDown = false;
  CanvasPosition mousePosition = CanvasPosition(0, 0);

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
              uiController.cookingMenu.visible = false;
              uiController.buildMenu.toggleVisible();
              break;
            case 'c':
              uiController.buildMenu.visible = false;
              uiController.cookingMenu.update();
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
      mouseDown = true;
      final CanvasPosition canvasPosition =
          renderer.getCursorPositionInCanvas(e);
      final int draggedItemId =
          uiController.inventory.dragClick(canvasPosition);
      if (draggedItemId != null) {
        //uiController.maybeDraggedItem = _world.getSoftObject(draggedItemId);
        print(uiController.maybeDraggedItem);
      }

      final WorldPosition mousePosition =
          renderer.getWorldPositionFromCanvasPosition(canvasPosition);
      final TilePosition tilePosition = mousePosition.toTilePosition();
      /*
      if (!session.player.isAdjacentToPosition(tilePosition)) {
        return;
      }
      */
      if (tilePosition.isInWorldBound) {
        /*
        final object = _world.getObjectAt(tilePosition);
        if (object != null) {
          final int relativeX = mousePosition.x.toInt() - object.box.left;
          final int relativeY = mousePosition.y.toInt() - object.box.top;
          if (!renderer.imageIsTransparent(renderer.solidImages[object.type],
              relativeX, relativeY, object.box)) {
            return;
          }
        }
        //final List<Tile> tiles = _world.getTileAround(tilePosition);
        for (Tile tile in tiles) {
          for (int i = tile.itemsOnGround.length - 1; i > -1; i--) {
            final int itemId = tile.itemsOnGround[i];
            //final SoftObject item = _world.getSoftObject(itemId);
            if (item.box.pointIsInBox(mousePosition.x, mousePosition.y)) {
              final int relativeX = mousePosition.x.toInt() - item.box.left;
              final int relativeY = mousePosition.y.toInt() - item.box.top;
              final image = renderer.softImages[item.type];
              if (!renderer.imageIsTransparent(
                  image, relativeX, relativeY, item.box)) {
                print('clicked on item ${item.type}!');
                print('$relativeX:$relativeY');
                uiController.maybeDraggedItem = item;
                break;
              }
            }
          }
        }
          */
      }
    });

    _canvas.onMouseMove.listen((MouseEvent e) {
      mousePosition.x = e.client.x.toDouble();
      mousePosition.y = e.client.y.toDouble();

      if ((e.movement.x != 0 || e.movement.y != 0) &&
          uiController.maybeDraggedItem != null) {
        uiController.dragging = true;
      }
    });
    _canvas.onMouseUp.listen((MouseEvent e) {
      mouseDown = false;
      if (!uiController.dragging) {
        uiController.dropItem();
      }
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
          if (uiController.buildMenu.leftClickAt(canvasPosition)) {
            return;
          }
        }
        if (uiController.craftingInventory.visible) {
          if (shift) {
            if (uiController.craftingInventory.shiftClick(canvasPosition)) {
              return;
            }
          }
        }
        if (uiController.cookingMenu.visible) {
          if (uiController.cookingMenu.clickAt(canvasPosition)) {
            return;
          }
          if (uiController.craftingInventory.okButton
              .tryLeftClick(canvasPosition)) {
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
          } else if (shift) {
            uiController.inventory.shiftLeftClick(canvasPosition);
          } else {
            uiController.inventory.leftClick(canvasPosition);
          }
          return;
        }
        if (!isRightClick) {
          if (uiController.cookButton.tryLeftClick(canvasPosition)) {
            return;
          }
          if (uiController.buildButton.tryLeftClick(canvasPosition)) {
            return;
          }
        }
        uiController.activeInventoryWindow = null;
        for (int i = 0; i < uiController.inventoryMenus.length; i++) {
          final inventory = uiController.inventoryMenus[i];
          if (inventory.contains(canvasPosition)) {
            inventory.active = true;
            uiController.activeInventoryWindow = inventory;

            if (uiController.dragging) {
              // TODO: drop item into inventory
              uiController.dropItem();
            } else if (isRightClick) {
              if (inventory.rightClick(canvasPosition)) {
                uiController.inventoryMenus.remove(inventory);
                i--;
              }
            } else if (shift) {
              inventory.shiftClick(canvasPosition);
            }
            return;
          } else {
            inventory.active = false;
          }
        }
        uiController.chat.input.active = false;
        final WorldPosition mousePosition =
            renderer.getWorldPositionFromCanvasPosition(canvasPosition);
        final TilePosition tilePosition = mousePosition.toTilePosition();
        if (tilePosition.isInWorldBound) {
          /*
          final object = _world.getTileAt(tilePosition.x, tilePosition.y).solidEntity;
          if (object == null) {
            if (!uiController.dragging) {
              clickOnGround(tilePosition);
            } else {
              final Tile tile = _world.getTileAt(tilePosition);
              if (uiController.maybeDraggedItem.ownerId == null) {
                print('Dropping item from the ground to the ground\n');
                final command = MoveItemCommand(
                    mousePosition, uiController.maybeDraggedItem.id);
                webSocketClient.sendCommand(command);
              } else {
                print('Dropping item from inventory\n');
                final command = DropItemCommand(
                    mousePosition, uiController.maybeDraggedItem.id);
                webSocketClient.sendCommand(command);
              }
              print('Items on this tile: ${tile.itemsOnGround}\n');
            }
          } else {
            if (e.button == 2) {
              rightClickOnSolidObject(object);
            } else {
              clickOnSolidObject(object);
            }
          }
                */
        } else {
          uiController.dropItem();
        }
      }
    });
    _canvas.onMouseWheel.listen((WheelEvent e) {
      renderer.increaseScale(-e.deltaY / 1000.0);
    });
  }

  void move(int x, int y) {
    final command = MoveClientCommand(x: x, y: y);
    if (command.canExecute(session.player, _world)) {
        webSocketClient.sendCommand(command);
    }
  }

  void rightClickOnSolidObject(SolidObject object) {
    print('Right clicking on object: $object\n');
    if (object.type == SolidObjectType.woodenChest ||
        object.type == SolidObjectType.box ||
        object.type == SolidObjectType.tree ||
        object.type == SolidObjectType.appleTree) {
      //webSocketClient.sendCommand(OpenInventoryCommand(object.id));
    }
  }

  void clickOnSolidObject(SolidObject object) {
    print('Clicking on object: $object\n');
    /*
    if (object == session.player) {
      print('Clicked on self.\n');
      return;
    }
    final int currentlyEquippedId = session.player.inventory.currentlyEquiped;
    final SoftObject currentlyEquipped =
        _world.getSoftObject(currentlyEquippedId);
    if (object.type == SolidObjectType.player && !currentlyEquipped.isWeapon) {
      return;
    }
    if (object.type != SolidObjectType.player &&
        !playerCanGather(session.player, _world, object.id)) {
      return;
    }
    final command = UseObjectOnSolidObjectCommand(object.id);
    webSocketClient.webSocket.send(jsonEncode(command));
    */
  }

  bool get canClick {
    return DateTime.now()
        .subtract(minDurationBetweenAction)
        .isAfter(lastClickTime);
  }

  void clickOnGround(TilePosition tilePosition) {
    print('clickOnGround $tilePosition\n');
    /*
    if (uiController.buildMenu.visible &&
        uiController.buildMenu.selectedType != null) {
      final Iterable<SoftObject> items =
          _world.getSoftObjects(uiController.craftingInventory.items);
      if (playerCanBuild(items, _world, uiController.buildMenu.selectedType,
          session.player, tilePosition)) {
        webSocketClient.webSocket.send(jsonEncode(BuildSolidObjectCommand(
            uiController.buildMenu.selectedType,
            tilePosition,
            uiController.craftingInventory.items)));
      }
    }
            */
  }
}
