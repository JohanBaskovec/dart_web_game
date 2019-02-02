import 'package:dart_game/client/ui/inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';

class EntityInventoryMenu extends InventoryMenu {
  SolidObject owner;
  SolidObject player;
  WebSocketClient webSocketClient;

  EntityInventoryMenu(this.owner, this.player, this.webSocketClient);

  @override
  void update() {
    updateItems(owner.inventory.items);
    /*
    for (InventoryButton button in buttons) {
      final int itemId = button.itemId;
      button.onRightClick = () {
        //webSocketClient.sendCommand(UseItemCommand(itemId));
      };
      button.onShiftLeftClick = () {
        //webSocketClient.sendCommand(TakeFromInventoryCommand(owner.id, itemId));
      };
    }
      */
  }
}
