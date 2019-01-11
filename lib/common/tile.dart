import 'package:json_annotation/json_annotation.dart';

part 'tile.g.dart';

@JsonSerializable(anyMap: true)
class Tile {
  /// Creates a new [Tile] from a JSON object.
  static Tile fromJson(Map<dynamic, dynamic> json) => _$TileFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$TileToJson(this);
}