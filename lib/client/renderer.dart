import 'dart:html';

import 'package:dart_game/common/canvas_position.dart';
import 'package:dart_game/common/game_objects/solid_game_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/tile_position.dart';

class Renderer {
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _ctx;

  Renderer(this._canvas)
      : _ctx = _canvas.getContext('2d') as CanvasRenderingContext2D;

  void render(World world) {
    _canvas.width = window.innerWidth;
    _canvas.height = window.innerHeight;
    _ctx.clearRect(0, 0, _canvas.width, _canvas.height);
    for (var player in world.players) {
      if (player != null) {
        _ctx.fillStyle = 'green';
        _ctx.fillRect(player.box.left, player.box.top, player.box.width,
            player.box.height);
      }
    }

    for (List<SolidGameObject> column in world.solidObjectColumns) {
      for (SolidGameObject object in column) {
        if (object != null) {
          _ctx.fillStyle = 'black';
          _ctx.fillRect(object.box.left, object.box.top, object.box.width,
              object.box.height);
        }
      }
    }
  }
}
