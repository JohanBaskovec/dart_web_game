import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

@JsonSerializable(anyMap: true)
class Inventory {
  bool private = false;
  int currentlyEquiped;
  List<int> items = [];
  int ownerId;

  bool get full => items.length == 9;

  void addItem(SoftObject item) {
    assert(item.id != null,
        'Item must have an id before being added to inventory!');
    if (items.length == 9) {
      return;
    }
    item.indexInInventory = items.length;
    items.add(item.id);
    print('Added $item to inventory at position ${item.indexInInventory}');
    currentlyEquiped ??= item.id;
  }

  /// Returns true when the stack at index stackIndex was removed.
  void removeItem(int stackIndex) {
    items.removeAt(stackIndex);
  }

  int operator[](int i) => items[i];

  int get size => items.length;

  /// Creates a new [Inventory] from a JSON object.
  static Inventory fromJson(Map<dynamic, dynamic> json) =>
      _$InventoryFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$InventoryToJson(this);

  @override
  String toString() {
    return 'Inventory{currentlyEquiped: $currentlyEquiped, items: $items}';
  }


}
