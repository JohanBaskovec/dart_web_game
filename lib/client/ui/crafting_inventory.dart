import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/ui.dart' as ui;
import 'package:dart_game/client/ui/inventory_menu.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';

class CraftingInventory extends InventoryMenu {
  List<int> items = [];
  Button okButton;
  WebSocketClient webSocketClient;

  CraftingInventory()
      : okButton = Button(),
        super() {
    okButton.onLeftClick = () {
      if (ui.cookingMenu.visible) {
        /*
        final Iterable<SoftObject> items = world.getSoftObjects(uiController.craftingInventory.items);
        final SoftObjectType selectedItemType = uiController.cookingMenu.selectedItemType;
        if (playerCanCraft(
            items, world,  selectedItemType, session.player)) {
          //webSocketClient.sendCommand(CraftCommand(selectedItemType, uiController.craftingInventory.items));
        }
        */
      }
    };
  }

  @override
  void update() {
    updateItems(items);
    for (InventoryButton button in buttons) {
      button.onShiftLeftClick = () {
        items.remove(button.itemId);
        update();
      };
    }
    okButton.visible = ui.cookingMenu.visible;
  }

  @override
  set box(Box value) {
    super.box = value;
    okButton.box = Box(left: box.left, top:  box.bottom + 3, width:  90, height:  30);
  }

  void removeItemsNotInInventory() {
    /*
    for (int i = 0; i < items.length; i++) {
      if (!session.player.inventory.contains(items[i])) {
        items.removeAt(i);
        i--;
      }
    }
    update();
    */
  }
}

