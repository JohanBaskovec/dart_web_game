import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/stack.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

class InventoryPopResult {
  int itemsLeft;
  SoftObject object;

  InventoryPopResult(this.itemsLeft, this.object);
}



@JsonSerializable(anyMap: true)
class Inventory {
  int currentlyEquiped;
  List<Stack> stacks = [];

  void addItem(SoftObject item) {
    assert(item.id != null, 'Item must have an id before being added to inventory!');
    var i = 0;
    Stack stack;
    for (; i < stacks.length; i++) {
      if (stacks[i].objectType == item.type) {
        stack = stacks[i];
      }
      if (stacks[i].isEmpty) {
        stacks.removeAt(i);
      }
    }
    if (stack == null) {
      stack = Stack(item.type);
      stacks.add(stack);
    }
    item.indexInInventory = i;
    stack.add(item.id);
    print('Added $item to inventory in stack $i');
    currentlyEquiped ??= item.id;
  }

  void removeFromStack(int stackIndex, [int n = 1]) {
    if (stacks[stackIndex].length >= n) {
      if (stacks[stackIndex].length == n) {
        stacks.removeAt(stackIndex);
      } else {
        stacks[stackIndex].removeRange(
            stacks[stackIndex].length - n, stacks[stackIndex].length);
      }
    } else {
      print('Attempting to remove $n items from stack $stackIndex'
          ', but stack\' length is ${stacks[stackIndex].length}!');
    }
  }

  int get size => stacks.length;

  /// Creates a new [Inventory] from a JSON object.
  static Inventory fromJson(Map<dynamic, dynamic> json) =>
      _$InventoryFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}
