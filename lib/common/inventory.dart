import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

@JsonSerializable(anyMap: true)
class Inventory {
  int currentlyEquiped;
  List<int> items = [];

  void addItem(SoftObject item) {
    assert(item.id != null,
        'Item must have an id before being added to inventory!');
    if (items.length == 9) {
      return;
    }
    item.indexInInventory = items.length;
    items.add(item.id);
    print('Added $item to inventory at position ${item.id}');
    currentlyEquiped ??= item.id;
  }

  /// Returns true when the stack at index stackIndex was removed.
  void removeItem(int stackIndex) {
    items.removeAt(stackIndex);
  }

  int get size => items.length;

  /// Creates a new [Inventory] from a JSON object.
  static Inventory fromJson(Map<dynamic, dynamic> json) =>
      _$InventoryFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}
