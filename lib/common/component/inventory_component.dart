import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/entity_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_component.g.dart';

class InventoryPopResult {
  int itemsLeft;
  List<int> object;

  InventoryPopResult(this.itemsLeft, this.object);
}

@JsonSerializable(anyMap: true)
class InventoryComponent {
  int currentlyEquiped;
  List<List<int>> stacks = [];

  void addItem(Entity item) {
    /*
    var i = 0;
    for (; i < stacks.length; i++) {
      if (stacks[i][0].type == item.type) {
        break;
      }
    }
    if (i == stacks.length) {
      stacks.add([]);
    }
    item.id = i;
    stacks[i].add(item);
    print('Added $item to inventory in stack $i');
    currentlyEquiped ??= item;
    */
  }

  void removeFromStack(int stackIndex, [int n = 1]) {
    /*
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
    */
  }

  int popFromStack(int stackIndex) {
    //return stacks[stackIndex].removeLast();
    return 0;
  }

  InventoryPopResult popFirstOfType(EntityType type) {
    /*
    for (int i = 0; i < stacks.length; i++) {
      if (stacks[i][0].type == type) {
        final InventoryPopResult result =
            InventoryPopResult(stacks[i].length - 1, popFromStack(i));
        if (stacks[i].isEmpty) {
          stacks.removeAt(i);
        }
        return result;
      }
    }
    */
    return null;
  }

  int get size => stacks.length;

  /// Creates a new [InventoryComponent] from a JSON object.
  static InventoryComponent fromJson(Map<dynamic, dynamic> json) =>
      _$InventoryComponentFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$InventoryComponentToJson(this);
}
