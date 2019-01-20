import 'package:dart_game/client/ui/build_menu.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/inventory_menu.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class ClientUiController extends UiController {
  BuildMenu buildMenu = BuildMenu();
  Chat chat = Chat();
  PlayerInventoryMenu inventory;
  List<InventoryMenu> inventoryMenus = [];
  World world;
  WebSocketClient webSocketClient;
  Session session;

  InventoryMenu activeInventoryWindow;

  ClientUiController(this.session, this.world)
      : inventory = PlayerInventoryMenu(session, null) {
    inventory.uiController = this;
  }

  @override
  void displayInventory(SolidObject target) {
    final inventoryMenu = InventoryMenu(
        Box(target.box.right, target.box.bottom, 120, 120),
        target,
        session.player,
        webSocketClient,
        this);
    inventoryMenus.add(inventoryMenu);
    activeInventoryWindow = inventoryMenu;
    return;
  }
}
