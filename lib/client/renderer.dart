import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/build_menu.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/inventory_menu.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/windows_manager.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/stack.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';

class Renderer {
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _ctx;
  double scale = 1;
  CanvasPosition cameraPosition;
  Map<SoftObjectType, ImageElement> softImages = {};
  Map<SolidObjectType, ImageElement> solidImages = {};
  BuildMenu buildMenu;
  Chat chat;
  PlayerInventoryMenu inventory;
  WindowsManager windowsManager;
  final Session session;

  Renderer(this._canvas, this.buildMenu, this.chat, this.inventory,
      this.windowsManager, this.session)
      : _ctx = _canvas.getContext('2d') as CanvasRenderingContext2D {
    for (SoftObjectType type in SoftObjectType.values) {
      softImages[type] = ImageElement();
      softImages[type].src = '/$type.png';
    }
    for (SolidObjectType type in SolidObjectType.values) {
      solidImages[type] = ImageElement();
      solidImages[type].src = '/$type.png';
    }

    resizeWindows();
  }

  void render(World world) {
    _canvas.width = window.innerWidth;
    _canvas.height = window.innerHeight;

    if (session.player != null) {
      moveCameraToPlayerPosition(session.player.tilePosition);
    }
    _ctx.scale(scale, scale);
    if (cameraPosition != null) {
      _ctx.translate(cameraPosition.x, cameraPosition.y);
    }
    _ctx.clearRect(0, 0, _canvas.width, _canvas.height);

    final Box renderingBox = Box(
      session.player.box.left - ((_canvas.width / 2) * (1 / scale)).toInt(),
      session.player.box.top - ((_canvas.height / 2) * (1 / scale)).toInt(),
      ((_canvas.width) * (1 / scale)).toInt(),
      ((_canvas.height) * (1 / scale)).toInt(),
    );
    for (SolidObject object in world.solidObjects) {
      if (object != null &&
          object.box.left < renderingBox.right &&
          object.box.right > renderingBox.left &&
          object.box.bottom > renderingBox.top &&
          object.box.top < renderingBox.bottom) {
        _ctx.drawImageScaled(solidImages[object.type], object.box.left,
            object.box.top, object.box.width, object.box.height);
      }
    }
    _ctx.setTransform(1, 0, 0, 1, 0, 0);
    if (session.player != null) {
      _ctx.fillStyle = 'black';
      inventory.update();
      _ctx.fillRect(inventory.box.left, inventory.box.top, inventory.box.width,
          inventory.box.height);
      final double widthPerStack = inventory.box.width / 9;
      for (var i = 0; i < session.player.inventory.stacks.length; i++) {
        final Stack stack = session.player.inventory.stacks[i];
        final double left = i * widthPerStack + inventory.box.left;
        _ctx.drawImageScaled(softImages[stack.objectType], left,
            inventory.box.top, widthPerStack, inventory.box.height);
        _ctx.fillStyle = 'white';
        _ctx.fillText(stack.length.toString(), left, inventory.box.bottom);
        _ctx.fillStyle = 'black';
      }
    }
    if (buildMenu.enabled) {
      _ctx.fillStyle = 'black';
      _ctx.fillRect(buildMenu.box.left, buildMenu.box.top, buildMenu.box.width,
          buildMenu.box.height);

      for (int i = 0; i < buildMenu.buttons.length; i++) {
        final button = buildMenu.buttons[i];
        _ctx.drawImageScaled(solidImages[button.type], button.box.left,
            button.box.top, button.box.width, button.box.height);
        _ctx.fillStyle = 'white';
        var k = 0;
        for (MapEntry<SoftObjectType, int> ingredientList
            in buildingRecipes[button.type].entries) {
          _ctx.fillText(
              '${ingredientList.key}: ${ingredientList.value}',
              buildMenu.box.left + 40,
              buildMenu.box.top + button.box.height * i + 15 + k * 10);
          k++;
        }
        _ctx.fillStyle = 'black';
      }
    }
    for (InventoryMenu inventory in windowsManager.inventoryMenus) {
      inventory.update();
      _ctx.fillStyle = 'black';
      _ctx.fillRect(inventory.box.left, inventory.box.top, inventory.box.width,
          inventory.box.height);
      final double widthPerStack = inventory.box.width / 9;
      for (var i = 0; i < inventory.buttons.length; i++) {
        final Stack stack = inventory.buttons[i].stack;
        final InventoryButton button = inventory.buttons[i];
        final type = stack.objectType;
        _ctx.drawImageScaled(softImages[type], button.box.left, button.box.top,
            button.box.width, button.box.height);
        _ctx.fillStyle = 'white';
        _ctx.fillText(
            stack.length.toString(), button.box.left, inventory.box.bottom);
        _ctx.fillStyle = 'black';
      }
    }
    if (chat.enabled) {
      _ctx.fillStyle = 'black';
      _ctx.fillRect(
          chat.box.left, chat.box.top, chat.box.width, chat.box.height);
      _ctx.fillStyle = 'white';
      _ctx.fillRect(chat.input.box.left, chat.input.box.top,
          chat.input.box.width, chat.input.box.height);
      _ctx.fillStyle = 'black';
      _ctx.fillText(
          chat.input.content, chat.input.box.left, chat.input.box.top + 8);
      _ctx.fillStyle = 'white';
      num height = 0;
      final List<String> lines = [];
      for (int i = chat.messages.length - 1; i > -1; i--) {
        final List<String> messageSplitBySpace =
            chat.messages[i].message.split(' ');
        num width = 0;
        int j = 0;
        while (j < messageSplitBySpace.length) {
          final StringBuffer line = StringBuffer();
          while (width < chat.box.width) {
            line.write('${messageSplitBySpace[j]} ');
            width += _ctx.measureText(messageSplitBySpace[j]).width;
            j++;
            if (j >= messageSplitBySpace.length) {
              break;
            }
          }
          lines.add(line.toString());
        }
        height += 8;
        if (height > chat.box.height) {
          break;
        }
      }
      for (int i = lines.length - 1; i > -1; i--) {
        _ctx.fillText(lines[i], chat.box.left, chat.input.box.top - 9 * i);
      }
    }
  }

  void increaseScale(double increase) {
    scale += increase;
    if (scale < 0.05) {
      scale = 0.05;
    }
    moveCameraToPlayerPosition(session.player.tilePosition);
  }

  CanvasPosition getCursorPositionInCanvas(MouseEvent event) {
    final rect = _canvas.getBoundingClientRect();
    final double x = event.client.x - rect.left;
    final double y = event.client.y - rect.top;
    return CanvasPosition(x, y);
  }

  WorldPosition getWorldPositionFromCanvasPosition(CanvasPosition position) {
    return WorldPosition((position.x * (1 / scale)) - cameraPosition.x,
        (position.y * (1 / scale)) - cameraPosition.y);
  }

  WorldPosition getCursorPositionInWorld(MouseEvent event) {
    final CanvasPosition canvasPosition = getCursorPositionInCanvas(event);
    return getWorldPositionFromCanvasPosition(canvasPosition);
  }

  void moveCameraToPlayerPosition(TilePosition tilePosition) {
    final double inverseScale = 1 / scale;
    final double x = -tilePosition.x * tileSize * 1.0 - tileSize / 2;
    final double y = -tilePosition.y * tileSize * 1.0 - tileSize / 2;
    final double canvasMiddleWidth = _canvas.width / 2.0;
    final double canvasMiddleHeight = _canvas.height / 2.0;

    final double translateX = x + canvasMiddleWidth * inverseScale;
    final double translateY = y + canvasMiddleHeight * inverseScale;
    cameraPosition = CanvasPosition(translateX, translateY);
  }

  void resizeWindows() {
    _canvas.width = window.innerWidth;
    _canvas.height = window.innerHeight;
    buildMenu.moveAndResize(
        Box(_canvas.width ~/ 10, 100, _canvas.width ~/ 2, _canvas.height ~/ 2));
    inventory.moveAndResize(Box(
        20,
        (_canvas.height - _canvas.height / 10).toInt(),
        (_canvas.width - 20 - _canvas.width / 3).toInt(),
        _canvas.height ~/ 11));
    chat.moveAndResize(Box(inventory.box.right + 20, inventory.box.top - 100,
        (_canvas.width / 3 - 40).toInt(), 100 + inventory.box.height));
  }
}
