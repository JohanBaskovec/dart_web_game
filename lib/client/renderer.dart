import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/input_manager.dart' as input;
import 'package:dart_game/client/ui/cooking_menu.dart';
import 'package:dart_game/client/ui/ui.dart' as ui;
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;
import 'package:dart_game/common/i18n.dart';
import 'package:dart_game/common/image_type.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/world_position.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;
CanvasElement canvasPlayerInventory;
CanvasRenderingContext2D ctxPlayerInventory;
CanvasElement canvasHeldItem;
CanvasRenderingContext2D ctxHeldItem;
double scale = 1;
CanvasPosition cameraPosition;
Map<ImageType, ImageElement> images = {};

void init() {
  canvas = document.getElementById('canvas') as CanvasElement;
  ctx = canvas.getContext('2d') as CanvasRenderingContext2D;
  canvasPlayerInventory =
      document.getElementById('canvas-player-inventory') as CanvasElement;
  ctxPlayerInventory =
      canvasPlayerInventory.getContext('2d') as CanvasRenderingContext2D;
  canvasHeldItem = document.getElementById('canvas-held-item') as CanvasElement;
  ctxHeldItem = canvasHeldItem.getContext('2d') as CanvasRenderingContext2D;
  for (ImageType type in ImageType.values) {
    images[type] = ImageElement();
    images[type].src = '/$type.png';
  }

  initCanvasSize();
}

void paintEverything() {
  paintScene();
  ui.paint();
}

void paintScene() {
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  moveCameraToPlayerPosition(currentSession.player.box);
  ctx.scale(scale, scale);
  if (cameraPosition != null) {
    ctx.translate(cameraPosition.x, cameraPosition.y);
  }

  final Box renderingBox = Box(
    left: currentSession.player.box.left -
        ((canvas.width / 2) * (1 / scale)).toInt(),
    top: currentSession.player.box.top -
        ((canvas.height / 2) * (1 / scale)).toInt(),
    width: ((canvas.width) * (1 / scale)).toInt(),
    height: ((canvas.height) * (1 / scale)).toInt(),
  );

  renderAllEntities(renderingBox);
  ctx.setTransform(1, 0, 0, 1, 0, 0);

}

void clearHeldItem() {
  ctxHeldItem.clearRect(0, 0, canvas.width, canvas.height);
}

void paintHeldItem() {
  ctxHeldItem.clearRect(0, 0, canvas.width, canvas.height);
  if (ui.maybeDraggedItem != null && ui.dragging) {
    ctxHeldItem.drawImageScaled(images[ui.maybeDraggedItem.imageType],
        input.mousePosition.x, input.mousePosition.y, 40, 40);
  }
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
    ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
    ctx.fillRect(ui.chat.box.left, ui.chat.box.top, ui.chat.box.width,
        ui.chat.box.height);
    ctx.fillStyle = 'white';
    ctx.fillRect(ui.chat.input.box.left, ui.chat.input.box.top,
        ui.chat.input.box.width, ui.chat.input.box.height);
    ctx.fillStyle = 'black';
    ctx.fillText(ui.chat.input.content, ui.chat.input.box.left + 3,
        ui.chat.input.box.top + 10);
    ctx.fillStyle = 'white';
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
          width += ctx.measureText(messageSplitBySpace[j]).width;
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
      ctx.fillText(
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
    ctx.fillStyle = 'black';
    ctx.fillRect(cookingMenu.box.left, cookingMenu.box.top,
        cookingMenu.box.width, cookingMenu.box.height);

    for (int i = 0; i < cookingMenu.buttons.length; i++) {
      final button = cookingMenu.buttons[i];
      ctx.drawImageScaled(images[button.objectType], button.box.left,
          button.box.top, button.box.width, button.box.height);
      ctx.fillStyle = 'white';
      var k = 0;
      final CraftingConfiguration craftingConfig =
          craftingRecipes[button.objectType];
      for (var requiredItems in craftingConfig.requiredItems.entries) {
        ctx.fillText(
            '${t(requiredItems.key.toString())}: ${requiredItems.value}',
            cookingMenu.box.left + 40,
            cookingMenu.box.top + button.box.height * i + 15 + k * 10);
        k++;
      }
      k++;
      ctx.fillStyle = 'black';
    }
  }
}

void renderBuildMenu() {
  final buildMenu = ui.buildMenu;
  if (buildMenu.visible) {
    ctx.fillStyle = 'black';
    ctx.fillRect(buildMenu.box.left, buildMenu.box.top, buildMenu.box.width,
        buildMenu.box.height);

    for (int i = 0; i < buildMenu.buttons.length; i++) {
      final button = buildMenu.buttons[i];
      ctx.drawImageScaled(images[button.type], button.box.left, button.box.top,
          button.box.width, button.box.height);
      ctx.fillStyle = 'white';
      var k = 0;
      final BuildingConfiguration craftingConfiguration =
          buildingRecipes[button.type];
      for (MapEntry<SoftObjectType, int> ingredientList
          in craftingConfiguration.requiredItems.entries) {
        ctx.fillText(
            '${t(ingredientList.key.toString())}: ${ingredientList.value}',
            buildMenu.box.left + 40,
            buildMenu.box.top + button.box.height * i + 15 + k * 10);
        k++;
      }
      ctx.fillStyle = 'black';
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

void initCanvasSize() {
  final int screenWidth = window.innerWidth - 10;
  final int screenHeight = window.innerHeight - 10;
  canvas.width = screenWidth;
  canvas.height = screenHeight;
  canvasPlayerInventory.width = screenWidth;
  canvasPlayerInventory.height = screenHeight;
  canvasHeldItem.width = screenWidth;
  canvasHeldItem.height = screenHeight;
  input.interactionCanvas.width = screenWidth;
  input.interactionCanvas.height = screenHeight;
  print('Window width: $screenWidth, window height: $screenHeight');
}

void fillBox(Box box) {
  ctx.fillRect(box.left, box.top, box.width, box.height);
}

void renderAllEntities(Box renderingBox) {
  final Entity player = currentSession.player;
  final Box playerBox = player.box;
  final entitiesInArea =
      world.getSurroundingRenderingComponentList(playerBox.left, playerBox.top);
  for (int z = 0; z < 3; z++) {
    for (List<Entity> entities in entitiesInArea) {
      if (entities != null) {
        for (Entity entity in entities) {
          if (entity != null &&
              entity.config.type == RenderingComponentType.values[z]) {
            renderEntity(entity, renderingBox);
          }
        }
      }
    }
  }
}

void renderEntity(Entity entity, Box renderingBox) {
  if (entity.box != null &&
      entity.box.left < renderingBox.right &&
      entity.box.right > renderingBox.left &&
      entity.box.bottom > renderingBox.top &&
      entity.box.top < renderingBox.bottom) {
    ctx.drawImageScaled(images[entity.imageType], entity.box.left,
        entity.box.top, entity.box.width, entity.box.height);
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
