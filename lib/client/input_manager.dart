import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/renderer.dart' as renderer;
import 'package:dart_game/client/ui/client_ui_controller.dart' as ui;
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/command/client/move_client_command.dart';
import 'package:dart_game/common/command/client/move_entity_client_command.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';

final _body = document.body;
bool canvasActive = false;
DateTime lastClickTime = DateTime.now();
Duration minDurationBetweenAction = Duration(milliseconds: 70);
bool shift = false;
bool mouseDown = false;
CanvasPosition mousePosition = CanvasPosition(0, 0);

void listen() {
  _body.onClick.listen((MouseEvent e) {
    if (e.target == renderer.canvas) {
      canvasActive = true;
    }
  });
  _body.onKeyDown.listen((KeyboardEvent e) {
    if (ui.chat.enabled && ui.chat.input.active) {
      ui.chat.type(e.key);
    } else {
      if (currentSession.loggedIn) {
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
            ui.cookingMenu.visible = false;
            ui.buildMenu.toggleVisible();
            break;
          case 'c':
            ui.buildMenu.visible = false;
            ui.cookingMenu.update();
            ui.cookingMenu.toggleVisible();
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
  renderer.canvas.onResize.listen((Event e) {
    renderer.initializeUi();
  });
  renderer.canvas.onContextMenu.listen((MouseEvent e) {
    e.preventDefault();
  });
  renderer.canvas.onMouseDown.listen((MouseEvent e) {
    print('MouseDown');
    mouseDown = true;
    final CanvasPosition canvasPosition = renderer.getCursorPositionInCanvas(e);
    final int draggedItemId = ui.playerInventory.dragClick(canvasPosition);
    if (draggedItemId != null) {
      //ui.maybeDraggedItem = _world.getSoftObject(draggedItemId);
      print(ui.maybeDraggedItem);
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
      final Tile tile = world.tiles[tilePosition.x][tilePosition.y];
      final Entity entity = tile.solidEntity;
      if (entity != null) {
        final int relativeX = mousePosition.x.toInt() - entity.box.left;
        final int relativeY = mousePosition.y.toInt() - entity.box.top;
        if (!renderer.imageIsTransparent(renderer.images[entity.imageType],
            relativeX, relativeY, entity.box)) {
          return;
        }
      }
      final List<Tile> tiles = world.getTileAround(tilePosition);
      for (Tile tile in tiles) {
        for (int i = tile.entitiesOnGround.length - 1; i > -1; i--) {
          final Entity entity = tile.entitiesOnGround[i];
          if (entity.box.pointIsInBox(mousePosition.x, mousePosition.y)) {
            final int relativeX = mousePosition.x.toInt() - entity.box.left;
            final int relativeY = mousePosition.y.toInt() - entity.box.top;
            final image = renderer.images[entity.imageType];
            if (!renderer.imageIsTransparent(
                image, relativeX, relativeY, entity.box)) {
              print('clicked on item ${entity.type}!');
              print('$relativeX:$relativeY');
              ui.maybeDraggedItem = entity;
              break;
            }
          }
        }
      }
    }
  });

  renderer.canvas.onMouseMove.listen((MouseEvent e) {
    mousePosition.x = e.client.x.toInt();
    mousePosition.y = e.client.y.toInt();

    if ((e.movement.x != 0 || e.movement.y != 0) &&
        ui.maybeDraggedItem != null) {
      ui.dragging = true;
    }
  });
  renderer.canvas.onMouseUp.listen((MouseEvent e) {
    mouseDown = false;
    if (!ui.dragging) {
      ui.dropItem();
    }
    if (currentSession.loggedIn == false) {
      return;
    }
    final bool isRightClick = e.button == 2;
    final CanvasPosition canvasPosition = renderer.getCursorPositionInCanvas(e);
    if (canClick) {
      if (renderer.cameraPosition == null) {
        return;
      }
      /*
      if (ui.buildMenu.visible) {
        if (ui.buildMenu.leftClickAt(canvasPosition)) {
          return;
        }
      }
      if (ui.craftingInventory.visible) {
        if (shift) {
          if (ui.craftingInventory.shiftClick(canvasPosition)) {
            return;
          }
        }
      }
      if (ui.cookingMenu.visible) {
        if (ui.cookingMenu.clickAt(canvasPosition)) {
          return;
        }
        if (ui.craftingInventory.okButton.tryLeftClick(canvasPosition)) {
          return;
        }
      }
      if (ui.chat.enabled) {
        if (!ui.chat.clickAt(canvasPosition)) {
          return;
        }
      }
      if (ui.playerInventory.contains(canvasPosition)) {
        if (isRightClick) {
          ui.playerInventory.rightClickAt(canvasPosition);
        } else if (shift) {
          ui.playerInventory.shiftLeftClick(canvasPosition);
        } else {
          ui.playerInventory.leftClick(canvasPosition);
        }
        return;
      }
        if (!isRightClick) {
          if (cookButton.tryLeftClick(canvasPosition)) {
            return;
          }
          if (buildButton.tryLeftClick(canvasPosition)) {
            return;
          }
        }
        */
      ui.activeInventoryWindow = null;
      for (int i = 0; i < ui.inventoryMenus.length; i++) {
        final inventory = ui.inventoryMenus[i];
        if (inventory.contains(canvasPosition)) {
          inventory.active = true;
          ui.activeInventoryWindow = inventory;

          if (ui.dragging) {
            // TODO: drop item into inventory
            ui.dropItem();
          } else if (isRightClick) {
            if (inventory.rightClick(canvasPosition)) {
              ui.inventoryMenus.remove(inventory);
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
      ui.chat.input.active = false;
      final WorldPosition mousePosition =
          renderer.getWorldPositionFromCanvasPosition(canvasPosition);

      final TilePosition tilePosition = mousePosition.toTilePosition();
      if (tilePosition.isInWorldBound) {
        final Tile tile = world.tiles[tilePosition.x][tilePosition.y];
        final Entity entity = tile.solidEntity;
        if (entity == null) {
          if (!ui.dragging) {
            clickOnGround(tilePosition);
          } else {
            final command = MoveEntityClientCommand(
                entityAreaId: ui.maybeDraggedItem.areaId,
                entityId: ui.maybeDraggedItem.id,
                x: mousePosition.x - ui.maybeDraggedItem.box.left,
                y: mousePosition.y - ui.maybeDraggedItem.box.top);
            if (command.canExecute(currentSession.player)) {
              webSocketClient.sendCommand(command);
            }
            /*
              if (ui.maybeDraggedItem.ownerId == null) {
                print('Dropping item from the ground to the ground\n');
                webSocketClient.sendCommand(command);
              } else {
                print('Dropping item from inventory\n');
                final command = DropItemCommand(
                    mousePosition, ui.maybeDraggedItem.id);
                webSocketClient.sendCommand(command);
              }
            print('Items on this tile: ${tile.itemsOnGround}\n');
              */
          }
        } else {
          /*
          if (e.button == 2) {
            rightClickOnSolidObject(object);
          } else {
            clickOnSolidObject(object);
          }
          */
        }
      } else {
        ui.dropItem();
      }
    }
  });
  renderer.canvas.onMouseWheel.listen((WheelEvent e) {
    renderer.increaseScale(-e.deltaY / 1000.0);
  });
}

void move(int x, int y) {
  final command = MoveClientCommand(x: x, y: y);
  if (command.canExecute(currentSession.player)) {
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
  return true;
}

void clickOnGround(TilePosition tilePosition) {
  print('clickOnGround $tilePosition\n');
  /*
    if (ui.buildMenu.visible &&
        ui.buildMenu.selectedType != null) {
      final Iterable<SoftObject> items =
          _world.getSoftObjects(ui.craftingInventory.items);
      if (playerCanBuild(items, _world, ui.buildMenu.selectedType,
          session.player, tilePosition)) {
        webSocketClient.webSocket.send(jsonEncode(BuildSolidObjectCommand(
            ui.buildMenu.selectedType,
            tilePosition,
            ui.craftingInventory.items)));
      }
    }
            */
}
