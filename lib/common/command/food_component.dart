import 'package:json_annotation/json_annotation.dart';

class FoodComponent {
  int hungerReduction;

  FoodComponent(this.hungerReduction);

  @override
  String toString() {
    return 'FoodComponent{hungerReduction: $hungerReduction}';
  }
}