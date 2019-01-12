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

  bool pointIsInBox(WorldPosition position) {
    return position.x > left &&
        position.x < right &&
        position.y > top &&
        position.y < bottom;
  }

  void move(int x, int y) {
    left += x;
    top += y;
    right = left + width;
    bottom = top + height;
  }
  
  /// Creates a new [Box] from a JSON object.
  static Box fromJson(Map<dynamic, dynamic> json) => _$BoxFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$BoxToJson(this);
}
