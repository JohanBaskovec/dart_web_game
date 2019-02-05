import 'package:dart_game/client/ui/build_menu.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/chat.dart';
import 'package:dart_game/client/ui/cooking_menu.dart';
import 'package:dart_game/client/ui/crafting_inventory.dart';
import 'package:dart_game/client/ui/entity_inventory_menu.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/session.dart';

class CookButton extends Button {}

List<EntityInventoryMenu> inventoryMenus = [];
Entity maybeDraggedItem;
bool dragging = false;

final Chat chat = Chat();
final BuildMenu buildMenu = BuildMenu();
final CraftingInventory craftingInventory = CraftingInventory();
final CookingMenu cookingMenu = CookingMenu();
final PlayerInventoryMenu playerInventory = PlayerInventoryMenu();

EntityInventoryMenu activeInventoryWindow;

@override
void displayInventory(SolidObject target) {
  /*
    final inventoryMenu =
        EntityInventoryMenu(target, session.player, webSocketClient);
    inventoryMenu.box = Box(left: target.box.right, top:  target.box.bottom, width:  120, height:  120);
    inventoryMenus.add(inventoryMenu);
    activeInventoryWindow = inventoryMenu;
    */
  return;
}

@override
void onPlayerMove() {
  /*
    for (int i = 0; i < inventoryMenus.length; i++) {
      final inventory = inventoryMenus[i];
      if (!inventory.owner.isAdjacentTo(session.player)) {
        inventoryMenus.remove(inventory);
        i--;
      }
    }
    */
  updateCraftingMenu();
}

void paint() {
  if (currentSession.player != null) {
    playerInventory.paint();
  }
  /*
  buildButton.box = Box(
      left: inventory.box.left,
      top: inventory.box.top - 33,
      width: 90,
      height: 30);
  cookButton.box = Box(
      left: inventory.box.left + buildButton.box.width + 3,
      top: inventory.box.top - 33,
      width: 90,
      height: 30);
  final int chatWidth = max(100, screenWidth - inventory.box.width - 60);
  chat.moveAndResize(Box(
      left: inventory.box.right + 20,
      top: inventory.box.top - 100,
      width: chatWidth,
      height: 100 + inventory.box.height));
  hunger.reinitialize(screenWidth, screenHeight);

  final int craftingMenuTop = hunger.box.bottom + 5;
  final int craftingMenuWidth =
      buildButton.box.width + cookButton.box.width + 3;
  buildMenu.box = Box(
      left: inventory.box.left,
      top: craftingMenuTop,
      width: craftingMenuWidth,
      height: buildButton.box.top - craftingMenuTop - 160);
  cookingMenu.box = Box(
      left: inventory.box.left,
      top: craftingMenuTop,
      width: craftingMenuWidth,
      height: buildMenu.box.height);

  craftingInventory.box = Box(
      left: buildMenu.box.left,
      top: buildMenu.box.bottom + 3,
      width: buildMenu.box.width,
      height: 120);
      */
}

@override
void updateCraftingMenu() {
  /*
  inventory.update();
  cookingMenu.update();
  craftingInventory.removeItemsNotInInventory();
  */
}

@override
void dropItemIfDragging({int id, int areaId}) {
  if (maybeDraggedItem != null && maybeDraggedItem.id == id && maybeDraggedItem.areaId == areaId) {
    dropItem();
  }
}

void dropItem() {
  dragging = false;
  maybeDraggedItem = null;
}
