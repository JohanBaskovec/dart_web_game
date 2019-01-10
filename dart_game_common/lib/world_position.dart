import 'package:json_annotation/json_annotation.dart';

part 'world_position.g.dart';

@JsonSerializable(anyMap: true)
class WorldPosition {
  int x;
  int y;

  WorldPosition([this.x, this.y]);
}
