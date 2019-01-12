import 'package:dart_game/common/game_objects/soft_game_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

@JsonSerializable(anyMap: true)
class Inventory {
  SoftGameObject currentlyEquiped;
  List<List<SoftGameObject>> items = [];

  void addItem(SoftGameObject item) {
    var i = 0;
    for (; i < items.length ; i++) {
      if (items[i][0].type == item.type) {
        break;
      }
    }
    if (i == items.length) {
      items.add([]);
    }
    item.index = i;
    items[i].add(item);
    print('Added $item to inventory in stack $i');
    currentlyEquiped ??= item;
  }

  int get size => items.length;
  
  /// Creates a new [Inventory] from a JSON object.
  static Inventory fromJson(Map<dynamic, dynamic> json) => _$InventoryFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}