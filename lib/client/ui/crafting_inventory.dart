import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/ui/inventory_menu.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/craft_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';

class CraftingInventory extends InventoryMenu {
  Session session;
  List<int> items = [];
  Button okButton;
  ClientUiController uiController;
  WebSocketClient webSocketClient;
  World world;

  CraftingInventory(this.session, this.uiController, this.world)
      : okButton = Button(),
        super() {
    okButton.onLeftClick = () {
      if (uiController.cookingMenu.visible) {
        final Iterable<SoftObject> items = world.getSoftObjects(uiController.craftingInventory.items);
        final SoftObjectType selectedItemType = uiController.cookingMenu.selectedItemType;
        if (playerCanCraft(
            items, world,  selectedItemType, session.player)) {
          webSocketClient.sendCommand(CraftCommand(selectedItemType, uiController.craftingInventory.items));
        }
      }
    };
  }

  @override
  void update() {
    updateItems(items);
    for (InventoryButton button in buttons) {
      button.onShiftLeftClick = () {
        items.remove(button.itemId);
        session.player.inventory.items.add(button.itemId);
        update();
      };
    }
    okButton.visible = uiController.cookingMenu.visible;
  }

  @override
  set box(Box value) {
    super.box = value;
    okButton.box = Box(box.left, box.bottom + 3, 90, 30);
  }

  void removeItemsNotInInventory() {
    for (int i = 0; i < items.length; i++) {
      if (!session.player.inventory.contains(items[i])) {
        items.removeAt(i);
        i--;
      }
    }
    update();
  }
}
