import 'package:json_annotation/json_annotation.dart';

part 'food_component.g.dart';

@JsonSerializable(anyMap: true)
class FoodComponent {
  int hungerReduction;

  FoodComponent(this.hungerReduction);

  /// Creates a new [FoodComponent] from a JSON object.
  static FoodComponent fromJson(Map<dynamic, dynamic> json) =>
      _$FoodComponentFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$FoodComponentToJson(this);

  @override
  String toString() {
    return 'FoodComponent{hungerReduction: $hungerReduction}';
  }
}