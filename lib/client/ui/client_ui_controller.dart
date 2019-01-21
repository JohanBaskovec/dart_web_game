import 'package:dart_game/client/ui/build_menu.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/cooking_menu.dart';
import 'package:dart_game/client/ui/hunger_ui.dart';
import 'package:dart_game/client/ui/inventory_menu.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class CookButton extends Button {}

class ClientUiController extends UiController {
  BuildMenu buildMenu = BuildMenu();
  Chat chat = Chat();
  PlayerInventoryMenu inventory;
  CookingMenu cookingMenu;
  List<InventoryMenu> inventoryMenus = [];
  Button buildButton = Button();
  Button cookButton;
  World world;
  WebSocketClient webSocketClient;
  Session session;
  HungerUi hunger;

  InventoryMenu activeInventoryWindow;

  ClientUiController(this.session, this.world)
      : inventory = PlayerInventoryMenu(session, null),
        hunger = HungerUi(session) {
    inventory.uiController = this;
    cookButton = CookButton();
    cookButton.onLeftClick = () {
      cookingMenu.visible = true;
    };
    cookingMenu = CookingMenu(session, world);
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

  @override
  void onPlayerMove() {
    for (int i = 0; i < inventoryMenus.length; i++) {
      final inventory = inventoryMenus[i];
      if (!inventory.owner.isAdjacentTo(session.player)) {
        inventoryMenus.remove(inventory);
        i--;
      }
    }
  }

  void initialize(int screenWidth, int screenHeight) {
    buildMenu.box = Box(screenWidth ~/ 10, 100, 200, screenHeight ~/ 2);
    inventory.reinitialize(screenWidth, screenHeight);
    buildButton.box = Box(inventory.box.left, inventory.box.top - 33, 90, 30);
    cookingMenu.box = Box(inventory.box.left, 50, 200, 500);
    cookButton.box = Box(inventory.box.left + buildButton.box.width + 3,
        inventory.box.top - 33, 90, 30);
    chat.moveAndResize(Box(inventory.box.right + 20, inventory.box.top - 100,
        screenWidth - inventory.box.width - 60, 100 + inventory.box.height));
    hunger.reinitialize(screenWidth, screenHeight);
  }
}
