import 'dart:html';

import 'package:dart_game_common/dart_game_common.dart';

class Renderer {
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _ctx;

  Renderer(this._canvas)
      : _ctx = _canvas.getContext('2d') as CanvasRenderingContext2D;

  void render(World world) {
    _ctx.clearRect(0, 0, _canvas.width, _canvas.height);
    for (var player in world.players) {
      if (player != null) {
        final CanvasPosition position =
            tilePositionToCanvasPosition(player.position);
        _ctx.fillStyle = 'green';
        _ctx.fillRect(position.x, position.y, 10, 10);
      }
    }
  }

  CanvasPosition tilePositionToCanvasPosition(TilePosition position) {
    return CanvasPosition(position.x * 10, position.y * 10);
  }
}
