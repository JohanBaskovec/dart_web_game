import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/player.dart';
import 'package:dart_game/common/game_objects/receipes.dart';
import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/ui/build_menu.dart';
import 'package:dart_game/common/world_position.dart';

class Renderer {
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _ctx;
  double scale = 1;
  CanvasPosition cameraPosition;
  Player player;
  Map<SoftGameObjectType, ImageElement> softImages = {};
  Map<SolidGameObjectType, ImageElement> solidImages = {};
  BuildMenu buildMenu;

  Renderer(this._canvas, this.buildMenu)
      : _ctx = _canvas.getContext('2d') as CanvasRenderingContext2D {
    for (SoftGameObjectType type in SoftGameObjectType.values) {
      softImages[type] = ImageElement();
      softImages[type].src = '/$type.png';
    }
    for (SolidGameObjectType type in SolidGameObjectType.values) {
      solidImages[type] = ImageElement();
      solidImages[type].src = '/$type.png';
    }

    _canvas.width = window.innerWidth;
    _canvas.height = window.innerHeight;
    buildMenu.moveAndResize(
        Box(_canvas.width / 10, 100, _canvas.width / 2, _canvas.height / 2));
  }

  void render(World world) {
    _canvas.width = window.innerWidth;
    _canvas.height = window.innerHeight;

    _ctx.scale(scale, scale);
    if (cameraPosition != null) {
      _ctx.translate(cameraPosition.x, cameraPosition.y);
    }
    _ctx.clearRect(0, 0, _canvas.width, _canvas.height);

    for (var player in world.players) {
      if (player != null) {
        _ctx.drawImageScaled(
            solidImages[SolidGameObjectType.player],
            player.box.left,
            player.box.top,
            player.box.width,
            player.box.height);
      }
    }

    for (List<SolidGameObject> column in world.solidObjectColumns) {
      for (SolidGameObject object in column) {
        if (object != null) {
          _ctx.drawImageScaled(
              solidImages[object.type],
              object.box.left,
              object.box.top,
              object.box.width,
              object.box.height);
        }
      }
    }
    _ctx.setTransform(1, 0, 0, 1, 0, 0);
    if (player != null) {
      _ctx.fillStyle = 'black';
      final Box menuBox = Box(
          _canvas.width / 10,
          _canvas.height - _canvas.height / 10,
          _canvas.width - _canvas.width / 5,
          _canvas.height / 11);
      _ctx.fillRect(menuBox.left, menuBox.top, menuBox.width, menuBox.height);
      final double widthPerStack = menuBox.width / 9;
      for (var i = 0; i < player.inventory.items.length; i++) {
        final List<SoftGameObject> stack = player.inventory.items[i];
        final double left = i * widthPerStack + menuBox.left;
        _ctx.drawImageScaled(softImages[stack[0].type], left, menuBox.top,
            widthPerStack, menuBox.height);
        _ctx.fillStyle = 'white';
        _ctx.fillText(stack.length.toString(), left, menuBox.bottom);
        _ctx.fillStyle = 'black';
      }
    }
    if (buildMenu.enabled) {
      _ctx.fillStyle = 'black';
      _ctx.fillRect(buildMenu.box.left, buildMenu.box.top, buildMenu.box.width,
          buildMenu.box.height);

      for (BuildMenuButton button in buildMenu.buttons) {
        _ctx.drawImageScaled(solidImages[button.type], button.box.left,
            button.box.top, button.box.width, button.box.height);
        _ctx.fillStyle = 'white';
        var k = 0;
        for (MapEntry<SoftGameObjectType, int> ingredientList
            in solidReceipes[button.type].entries) {
          _ctx.fillText('${ingredientList.key}: ${ingredientList.value}',
              buildMenu.box.left + 40, buildMenu.box.top + 15 * k + 15);
          k++;
        }
        _ctx.fillStyle = 'black';
      }
    }
  }

  void increaseScale(double increase) {
    scale += increase;
    if (scale < 0.05) {
      scale = 0.05;
    }
    moveCameraToPlayerPosition(player.tilePosition);
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
}
