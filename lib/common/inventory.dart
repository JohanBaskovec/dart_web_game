import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/stack.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

class InventoryPopResult {
  int itemsLeft;
  SoftGameObject object;

  InventoryPopResult(this.itemsLeft, this.object);
}



@JsonSerializable(anyMap: true)
class Inventory {
  int currentlyEquiped;
  List<Stack> stacks = [];

  void addItem(SoftGameObject item) {
    var i = 0;
    for (; i < stacks.length; i++) {
      if (stacks[i].objectType == item.type) {
        break;
      }
    }
    if (i == stacks.length) {
      stacks.add(Stack(item.type));
    }
    item.index = i;
    stacks[i].add(item.id);
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

  int popFromStack(int stackIndex) {
    return stacks[stackIndex].removeLast();
  }

  int get size => stacks.length;

  /// Creates a new [Inventory] from a JSON object.
  static Inventory fromJson(Map<dynamic, dynamic> json) =>
      _$InventoryFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}
