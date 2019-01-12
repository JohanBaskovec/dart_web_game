import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

@JsonSerializable(anyMap: true)
class Inventory {
  SoftGameObject currentlyEquiped;
  List<SoftGameObject> items = [];

  void addItem(SoftGameObject item) {
    item.index = items.length;
    items.add(item);
    currentlyEquiped ??= item;
    print('Added $item to inventory');
  }

  int get size => items.length;
  
  SoftGameObject removeLast() => items.removeLast();

  /// Creates a new [Inventory] from a JSON object.
  static Inventory fromJson(Map<dynamic, dynamic> json) => _$InventoryFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}