import 'package:dart_game/common/game_objects/solid_object.dart';

abstract class UiController {
  void onPlayerMove();
  void displayInventory(SolidObject target);

  void updateCraftingMenu() {}
}