import 'package:dart_game/common/world_position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'box.g.dart';

@JsonSerializable(anyMap: true)
class Box {
  int left;
  int right;
  int top;
  int bottom;
  int width;
  int height;

  Box(this.left, this.top, this.width, this.height)
      : right = left + width,
        bottom = top + height;

  bool pointIsInBox(double x, double y) {
    return x >= left &&
        x <= right &&
        y >= top &&
        y <= bottom;
  }

  void move(int x, int y) {
    left += x;
    top += y;
    right = left + width;
    bottom = top + height;
  }

  void moveTo(int x, int y) {
    left = x;
    top = y;
    right = x + width;
    bottom = y + height;
  }

  void clamp(Box worldBox) {
    if (left < worldBox.left) {
      left = worldBox.left;
    }
    if (right > worldBox.right) {
      right = worldBox.right;
    }
    if (top < worldBox.top) {
      top = worldBox.top;
    }
    if (bottom > worldBox.bottom) {
      bottom = worldBox.bottom;
    }
    width = right - left;
    height = bottom - top;
  }

  @override
  String toString() {
    return 'Box{left: $left, right: $right, top: $top, bottom: $bottom, width: $width, height: $height}';
  }

  /// Creates a new [Box] from a JSON object.
  static Box fromJson(Map<dynamic, dynamic> json) => _$BoxFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$BoxToJson(this);
}
