import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';

class CookingMenu extends UiElement {
  Session session;
  World world;
  List<CookingMenuButton> buttons = [];

  CookingMenu(this.session, this.world);

  @override
  set box(Box value) {
    super.box = value;
    update();
  }

  void update() {
    buttons = [];
    var i = 0;
    for (MapEntry<SoftObjectType, CraftingConfiguration> config
        in craftingRecipes.entries) {
      buttons.add(CookingMenuButton(
          config.key, Box(box.left, box.top + 40 * i, 40, 40)));
      i++;
    }
  }
}

class CookingMenuButton extends Button {
  SoftObjectType objectType;

  CookingMenuButton(this.objectType, Box box) : super(box);
}
