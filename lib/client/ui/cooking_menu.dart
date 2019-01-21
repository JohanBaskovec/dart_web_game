import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';

class CookingMenu extends UiElement {
  Session session;
  World world;
  List<CookingMenuButton> buttons = [];

  CookingMenu(this.session, this.world);
}

class CookingMenuButton extends Button {
  SoftObjectType objectType;
}
