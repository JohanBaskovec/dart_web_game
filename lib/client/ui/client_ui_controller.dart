import 'dart:math';

import 'package:dart_game/client/ui/build_menu.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/cooking_menu.dart';
import 'package:dart_game/client/ui/crafting_inventory.dart';
import 'package:dart_game/client/ui/entity_inventory_menu.dart';
import 'package:dart_game/client/ui/hunger_ui.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/ui_controller.dart';

class CookButton extends Button {}

class ClientUiController extends UiController {
  BuildMenu buildMenu;
  Chat chat = Chat();
  PlayerInventoryMenu inventory;
  CraftingInventory craftingInventory;
  CookingMenu cookingMenu;
  List<EntityInventoryMenu> inventoryMenus = [];
  Button buildButton = Button();
  Button cookButton;
  World world;
  WebSocketClient _webSocketClient;
  SoftObject draggedItem;

  WebSocketClient get webSocketClient => _webSocketClient;

  set webSocketClient(WebSocketClient value) {
    cookingMenu.webSocketClient = value;
    craftingInventory.webSocketClient = value;
    _webSocketClient = value;
  }

  Session session;
  HungerUi hunger;

  EntityInventoryMenu activeInventoryWindow;

  ClientUiController(this.session, this.world)
      : inventory = PlayerInventoryMenu(session, null),
        hunger = HungerUi(session),
        buildMenu = BuildMenu(session) {
    inventory.uiController = this;
    cookButton = CookButton();
    cookButton.onLeftClick = () {
      buildMenu.visible = false;
      cookingMenu.toggleVisible();
      craftingInventory.visible = buildMenu.visible || cookingMenu.visible;
    };
    buildButton.onLeftClick = () {
      cookingMenu.visible = false;
      buildMenu.toggleVisible();
      craftingInventory.visible = buildMenu.visible || cookingMenu.visible;
    };
    cookingMenu = CookingMenu(session, world, null);
    cookingMenu.visible = true;
    buildMenu.visible = false;

    craftingInventory = CraftingInventory(session, this, world);
  }

  @override
  void displayInventory(SolidObject target) {
    final inventoryMenu = EntityInventoryMenu(target, session.player, webSocketClient);
    inventoryMenu.box = Box(target.box.right, target.box.bottom, 120, 120);
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
    updateCraftingMenu();
  }

  void initialize(int screenWidth, int screenHeight) {
    inventory.reinitialize(screenWidth, screenHeight);
    buildButton.box = Box(inventory.box.left, inventory.box.top - 33, 90, 30);
    cookButton.box =
        Box(inventory.box.left + buildButton.box.width + 3, inventory.box.top - 33, 90, 30);
    final int chatWidth = max(100, screenWidth - inventory.box.width - 60);
    chat.moveAndResize(Box(
        inventory.box.right + 20, inventory.box.top - 100, chatWidth, 100 + inventory.box.height));
    hunger.reinitialize(screenWidth, screenHeight);

    final int craftingMenuTop = hunger.box.bottom + 5;
    final int craftingMenuWidth = buildButton.box.width + cookButton.box.width + 3;
    buildMenu.box = Box(inventory.box.left, craftingMenuTop, craftingMenuWidth,
        buildButton.box.top - craftingMenuTop - 160);
    cookingMenu.box = Box(inventory.box.left, craftingMenuTop, craftingMenuWidth,
        buildMenu.box.height);

    craftingInventory.box =
        Box(buildMenu.box.left, buildMenu.box.bottom + 3, buildMenu.box.width, 120);
  }

  @override
  void updateCraftingMenu() {
    cookingMenu.update();
    craftingInventory.removeItemsNotInInventory();
  }
}
