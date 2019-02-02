import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/common/box.dart';

abstract class InventoryMenu extends UiElement {
  List<InventoryButton> buttons = [];
  int columns = 3;
  int rows = 3;
  bool active = true;

  InventoryMenu();

  void update();

  void updateItems(List<int> items) {
    final int widthPerButton = box.width ~/ columns;
    final int heightPerButton = box.height ~/ rows;
    buttons = [];
    int row = 0;
    int column = 0;
    for (var i = 0; i < items.length; i++) {
      final int left = box.left + column * widthPerButton;
      final int top = box.top + row * heightPerButton;
      final newButton = InventoryButton(items[i]);
      newButton.box = Box(left: left, top:  top, width:  widthPerButton, height:  heightPerButton);
      buttons.add(newButton);
      column++;
      if (column == columns) {
        column = 0;
        row++;
      }
    }
  }

  bool shiftClick(CanvasPosition canvasPosition) {
    for (Button button in buttons) {
      if (button.tryShiftLeftClick(canvasPosition)) {
        return true;
      }
    }
    return false;
  }

  /// Returns true when clicking on the window, but outside the buttons
  bool rightClick(CanvasPosition canvasPosition) {
    for (Button button in buttons) {
      if (button.tryRightClick(canvasPosition)) {
        return false;
      }
    }
    return true;
  }
}

