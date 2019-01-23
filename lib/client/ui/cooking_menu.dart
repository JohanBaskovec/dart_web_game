import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/button.dart';
import 'package:dart_game/client/ui/ui_element.dart';
import 'package:dart_game/client/web_socket_client.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/command/client/craft_command.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/session.dart';

class CookingMenu extends UiElement {
  Session session;
  World world;
  List<CookingMenuButton> buttons = [];
  WebSocketClient webSocketClient;
  SoftObjectType selectedItemType;

  CookingMenu(this.session, this.world, this.webSocketClient);

  @override
  set box(Box value) {
    super.box = value;
    update();
  }

  void update() {
    if (session == null || session.playerId == null) {
      return;
    }
    buttons = [];
    var i = 0;
    for (MapEntry<SoftObjectType, CraftingConfiguration> config in craftingRecipes.entries) {
      final Iterable<SoftObject> itemsInInventory =
          session.player.inventory.items.map(world.getSoftObject);
      if (playerCanCraft(itemsInInventory, world, config.key, session.player)) {
        final button = CookingMenuButton(config.key, Box(box.left, box.top + 40 * i, 40, 40));
        button.onLeftClick = () {
          selectedItemType = button.objectType;
        };
        buttons.add(button);
        i++;
      }
    }
  }

  bool clickAt(CanvasPosition canvasPosition) {
    if (contains(canvasPosition)) {
      for (CookingMenuButton button in buttons) {
        button.tryLeftClick(canvasPosition);
      }
      return true;
    }
    return false;
  }
}

class CookingMenuButton extends Button {
  SoftObjectType objectType;

  CookingMenuButton(this.objectType, Box box) : super(box);
}
