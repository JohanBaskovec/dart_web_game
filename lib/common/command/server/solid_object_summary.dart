import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'solid_object_summary.g.dart';

@JsonSerializable(anyMap: true)
class SolidObjectSummary {
  int id;
  SolidObjectType objectType;

  SolidObjectSummary(this.id, this.objectType);

  /// Creates a new [SolidObjectSummary] from a JSON object.
  static SolidObjectSummary fromJson(Map<dynamic, dynamic> json) =>
      _$SolidObjectSummaryFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$SolidObjectSummaryToJson(this);

  @override
  String toString() {
    return 'SolidObjectSummary{id: $id, objectType: $objectType}';
  }
}
