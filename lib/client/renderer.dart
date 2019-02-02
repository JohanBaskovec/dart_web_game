import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart' as ui;
import 'package:dart_game/client/ui/cooking_menu.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/i18n.dart';
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/world_position.dart';

CanvasElement canvas;
CanvasRenderingContext2D _ctx;
double scale = 1;
CanvasPosition cameraPosition;
Map<ImageType, ImageElement> images = {};

void init() {
  canvas = document.getElementById('canvas') as CanvasElement;
  _ctx = canvas.getContext('2d') as CanvasRenderingContext2D;
  for (ImageType type in ImageType.values) {
    images[type] = ImageElement();
    images[type].src = '/$type.png';
  }

  initializeUi();
}

void render() {
  _ctx.setTransform(1, 0, 0, 1, 0, 0);
  _ctx.clearRect(0, 0, canvas.width, canvas.height);
  if (currentSession.loggedIn == false) {
    return;
  }

  moveCameraToPlayerPosition(currentSession.player.renderingComponent.box);
  _ctx.scale(scale, scale);
  if (cameraPosition != null) {
    _ctx.translate(cameraPosition.x, cameraPosition.y);
  }

  final Box renderingBox = Box(
    left: currentSession.player.renderingComponent.box.left -
        ((canvas.width / 2) * (1 / scale)).toInt(),
    top: currentSession.player.renderingComponent.box.top -
        ((canvas.height / 2) * (1 / scale)).toInt(),
    width: ((canvas.width) * (1 / scale)).toInt(),
    height: ((canvas.height) * (1 / scale)).toInt(),
  );

  renderAllEntities(renderingBox);
  /*

    _ctx.setTransform(1, 0, 0, 1, 0, 0);
    renderBuildButton();
    renderCookButton();
    renderPlayerInventory(world);
    renderBuildMenu(world);
    renderCraftingInventory(world);
    renderCookingMenu();
    renderInventoryMenus(world);
    renderChat(world);
    renderHungerMeter();
    if (ui.maybeDraggedItem != null && ui.dragging) {
      _ctx.drawImageScaled(softImages[ui.maybeDraggedItem.type],
          inputManager.mousePosition.x, inputManager.mousePosition.y, 40, 40);
    }
    */
}

void renderHungerMeter() {
  /*
    final HungerUi hunger = ui.hunger;
    _ctx.fillStyle = 'black';
    fillBox(hunger.box);
    _ctx.fillStyle = 'white';
    _ctx.fillText('Hunger: ${hunger.session.player.hungerComponent.hunger}',
        hunger.box.left + 6, hunger.box.top + 19);
        */
}

void renderChat() {
  if (ui.chat.enabled) {
    _ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
    _ctx.fillRect(ui.chat.box.left, ui.chat.box.top, ui.chat.box.width,
        ui.chat.box.height);
    _ctx.fillStyle = 'white';
    _ctx.fillRect(ui.chat.input.box.left, ui.chat.input.box.top,
        ui.chat.input.box.width, ui.chat.input.box.height);
    _ctx.fillStyle = 'black';
    _ctx.fillText(ui.chat.input.content, ui.chat.input.box.left + 3,
        ui.chat.input.box.top + 10);
    _ctx.fillStyle = 'white';
    num height = 0;
    final List<String> lines = [];
    for (int i = world.messages.length - 1; i > -1; i--) {
      final List<String> messageSplitBySpace =
          world.messages[i].message.split(' ');
      num width = 0;
      int j = 0;
      while (j < messageSplitBySpace.length) {
        final StringBuffer line = StringBuffer();
        while (width < ui.chat.box.width) {
          line.write('${messageSplitBySpace[j]} ');
          width += _ctx.measureText(messageSplitBySpace[j]).width;
          j++;
          if (j >= messageSplitBySpace.length) {
            break;
          }
        }
        lines.add(line.toString());
        height += 18;
      }
      if (height > ui.chat.box.height) {
        break;
      }
    }
    for (int i = lines.length - 1; i > -1; i--) {
      _ctx.fillText(
          lines[i], ui.chat.box.left + 3, ui.chat.input.box.top - 15 * i - 5);
    }
  }
}

void renderInventoryMenus() {
  /*
    for (EntityInventoryMenu inventory in ui.inventoryMenus) {
      inventory.update();
      _ctx.fillStyle = 'black';
      _ctx.fillRect(inventory.box.left, inventory.box.top, inventory.box.width,
          inventory.box.height);
      for (var i = 0; i < inventory.buttons.length; i++) {
        final int itemId = inventory.buttons[i].itemId;
        final SoftObject item = world.getSoftObject(itemId);
        final InventoryButton button = inventory.buttons[i];
        final type = item.type;
        _ctx.drawImageScaled(softImages[type], button.box.left, button.box.top,
            button.box.width, button.box.height);
      }
    }
    */
}

void renderCookingMenu() {
  final CookingMenu cookingMenu = ui.cookingMenu;
  if (cookingMenu.visible) {
    _ctx.fillStyle = 'black';
    _ctx.fillRect(cookingMenu.box.left, cookingMenu.box.top,
        cookingMenu.box.width, cookingMenu.box.height);

    for (int i = 0; i < cookingMenu.buttons.length; i++) {
      final button = cookingMenu.buttons[i];
      _ctx.drawImageScaled(images[button.objectType], button.box.left,
          button.box.top, button.box.width, button.box.height);
      _ctx.fillStyle = 'white';
      var k = 0;
      final CraftingConfiguration craftingConfig =
          craftingRecipes[button.objectType];
      for (var requiredItems in craftingConfig.requiredItems.entries) {
        _ctx.fillText(
            '${t(requiredItems.key.toString())}: ${requiredItems.value}',
            cookingMenu.box.left + 40,
            cookingMenu.box.top + button.box.height * i + 15 + k * 10);
        k++;
      }
      k++;
      _ctx.fillStyle = 'black';
    }
  }
}

void renderBuildMenu() {
  final buildMenu = ui.buildMenu;
  if (buildMenu.visible) {
    _ctx.fillStyle = 'black';
    _ctx.fillRect(buildMenu.box.left, buildMenu.box.top, buildMenu.box.width,
        buildMenu.box.height);

    for (int i = 0; i < buildMenu.buttons.length; i++) {
      final button = buildMenu.buttons[i];
      _ctx.drawImageScaled(images[button.type], button.box.left, button.box.top,
          button.box.width, button.box.height);
      _ctx.fillStyle = 'white';
      var k = 0;
      final BuildingConfiguration craftingConfiguration =
          buildingRecipes[button.type];
      for (MapEntry<SoftObjectType, int> ingredientList
          in craftingConfiguration.requiredItems.entries) {
        _ctx.fillText(
            '${t(ingredientList.key.toString())}: ${ingredientList.value}',
            buildMenu.box.left + 40,
            buildMenu.box.top + button.box.height * i + 15 + k * 10);
        k++;
      }
      _ctx.fillStyle = 'black';
    }
  }
}

void renderCraftingInventory() {
  /*
    final inventory = ui.craftingInventory;
    if (inventory.visible) {
      _ctx.fillStyle = 'black';
      _ctx.fillRect(inventory.box.left, inventory.box.top, inventory.box.width,
          inventory.box.height);
      for (var i = 0; i < inventory.buttons.length; i++) {
        final int itemId = inventory.buttons[i].itemId;
        final SoftObject item = world.getSoftObject(itemId);
        final InventoryButton button = inventory.buttons[i];
        final type = item.type;
        _ctx.drawImageScaled(softImages[type], button.box.left, button.box.top,
            button.box.width, button.box.height);
      }

      _ctx.fillStyle = 'black';
      fillBox(inventory.okButton.box);
      _ctx.fillStyle = 'white';
      _ctx.font = '12px gameFont';
      _ctx.fillText('OK', inventory.okButton.box.left + 28,
          inventory.okButton.box.top + 19);
    }
    */
}

void renderPlayerInventory() {
  /*
    if (session.player != null) {
      ui.inventory.update();
      _ctx.fillStyle = 'black';
      _ctx.fillRect(
          ui.inventory.box.left,
          ui.inventory.box.top,
          ui.inventory.box.width,
          ui.inventory.box.height);
      for (var i = 0; i < ui.inventory.buttons.length; i++) {
        final InventoryButton button = ui.inventory.buttons[i];
        final int itemId = button.itemId;
        final SoftObject item = world.getSoftObject(itemId);
        _ctx.drawImageScaled(softImages[item.type], button.box.left,
            button.box.top, button.box.width, button.box.height);
      }
    }
    */
}

/*
  void renderCookButton() {
    _ctx.fillStyle = 'black';
    fillBox(ui.cookButton.box);
    _ctx.fillStyle = 'white';
    _ctx.font = '12px gameFont';
    _ctx.fillText('Cook', ui.cookButton.box.left + 28,
        ui.cookButton.box.top + 19);
  }

  void renderBuildButton() {
    _ctx.fillStyle = 'black';
    fillBox(ui.buildButton.box);
    _ctx.fillStyle = 'white';
    _ctx.font = '12px gameFont';
    _ctx.fillText('Build', ui.buildButton.box.left + 28,
        ui.buildButton.box.top + 19);
  }
  */

void increaseScale(double increase) {
  /*
    scale += increase;
    if (scale < 0.05) {
      scale = 0.05;
    }
    moveCameraToPlayerPosition(session.player.tilePosition);
    */
}

CanvasPosition getCursorPositionInCanvas(MouseEvent event) {
  final rect = canvas.getBoundingClientRect();
  final int x = event.client.x - rect.left;
  final int y = event.client.y - rect.top;
  return CanvasPosition(x, y);
}

WorldPosition getWorldPositionFromCanvasPosition(CanvasPosition position) {
  if (cameraPosition == null) {
    return WorldPosition(0, 0);
  }
  return WorldPosition(((position.x * (1 / scale)) - cameraPosition.x).toInt(),
      ((position.y * (1 / scale)) - cameraPosition.y).toInt());
}

WorldPosition getCursorPositionInWorld(MouseEvent event) {
  final CanvasPosition canvasPosition = getCursorPositionInCanvas(event);
  return getWorldPositionFromCanvasPosition(canvasPosition);
}

void moveCameraToPlayerPosition(Box box) {
  final double inverseScale = 1 / scale;
  final double x = -box.left * 1.0 - tileSize / 2;
  final double y = -box.top * 1.0 - tileSize / 2;
  final double canvasMiddleWidth = canvas.width / 2.0;
  final double canvasMiddleHeight = canvas.height / 2.0;

  final int translateX = (x + canvasMiddleWidth * inverseScale).toInt();
  final int translateY = (y + canvasMiddleHeight * inverseScale).toInt();
  cameraPosition = CanvasPosition(translateX, translateY);
}

void initializeUi() {
  final int screenWidth = window.innerWidth - 10;
  final int screenHeight = window.innerHeight - 10;
  canvas.width = screenWidth;
  canvas.height = screenHeight;
  print('Window width: $screenWidth, window height: $screenHeight');
  ui.initialize(screenWidth, screenHeight);
}

void fillBox(Box box) {
  _ctx.fillRect(box.left, box.top, box.width, box.height);
}

void renderAllEntities(Box renderingBox) {
  final Entity player = currentSession.player;
  final Box playerBox = player.renderingComponent.box;
  final surroundingRenderings =
      world.getSurroundingRenderingComponentList(playerBox.left, playerBox.top);
  for (int z = 0; z < 3; z++) {
    for (List<RenderingComponent> renderingsList in surroundingRenderings) {
      if (renderingsList != null) {
        for (RenderingComponent rendering in renderingsList) {
          if (rendering != null &&
              rendering.config.type == RenderingComponentType.values[z]) {
            renderRenderingComponent(rendering, renderingBox);
          }
        }
      }
    }
  }
}

void renderRenderingComponent(RenderingComponent rendering, Box renderingBox) {
  if (rendering.box != null &&
      rendering.box.left < renderingBox.right &&
      rendering.box.right > renderingBox.left &&
      rendering.box.bottom > renderingBox.top &&
      rendering.box.top < renderingBox.bottom) {
    _ctx.drawImageScaled(images[rendering.imageType], rendering.box.left,
        rendering.box.top, rendering.box.width, rendering.box.height);
  }
}

bool imageIsTransparent(ImageElement image, int x, int y, Box box) {
  final CanvasElement imgCanvas = document.getElementById('fake-canvas');
  final CanvasRenderingContext2D ctx = imgCanvas.getContext('2d');
  imgCanvas.width = image.width;
  imgCanvas.height = image.height;
  ctx.drawImageScaled(image, 0, 0, box.width, box.height);
  final data = ctx.getImageData(x, y, 1, 1).data;
  final int pixelTransparency = data[3];
  return pixelTransparency < 40;
}
