import 'package:dart_game/common/game_objects/soft_object.dart';

class InventoryComponent {
  bool private = false;
  int currentlyEquiped;
  List<int> items = [];
  int _ownerId;

  int get ownerId => _ownerId;

  set ownerId(int value) {
    _ownerId = value;
  }

  bool get full => items.length == 9;

  void addItem(SoftObject item) {
    assert(item.id != null,
        'Item must have an id before being added to inventory!');
    if (items.length == 9) {
      return;
    }
    item.ownerId = ownerId;
    item.indexInInventory = items.length;
    items.add(item.id);
    print('Added $item to inventory at position ${item.indexInInventory}\n');
    currentlyEquiped ??= item.id;
  }

  /// Returns true when the stack at index stackIndex was removed.
  void removeItem(int stackIndex) {
    items.removeAt(stackIndex);
  }

  bool contains(int id) {
    return items.contains(id);
  }

  int operator [](int i) => items[i];

  int get size => items.length;

  @override
  String toString() {
    return 'Inventory{currentlyEquiped: $currentlyEquiped, items: $items}';
  }
}
