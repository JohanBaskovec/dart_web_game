import 'dart:html';

import 'package:dart_game/client/canvas_position.dart';
import 'package:dart_game/client/client_world.dart';
import 'package:dart_game/client/input_manager.dart';
import 'package:dart_game/client/ui/client_ui_controller.dart';
import 'package:dart_game/client/ui/cooking_menu.dart';
import 'package:dart_game/client/ui/entity_inventory_menu.dart';
import 'package:dart_game/client/ui/hunger_ui.dart';
import 'package:dart_game/client/ui/player_inventory_menu.dart';
import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/building.dart';
import 'package:dart_game/common/constants.dart';
import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:dart_game/common/i18n.dart';
import 'package:dart_game/common/session.dart';
import 'package:dart_game/common/tile.dart';
import 'package:dart_game/common/tile_position.dart';
import 'package:dart_game/common/world_position.dart';

class Renderer {
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _ctx;
  double scale = 1;
  CanvasPosition cameraPosition;
  Map<SoftObjectType, ImageElement> softImages = {};
  Map<SolidObjectType, ImageElement> solidImages = {};
  Map<TileType, ImageElement> tileImages = {};
  final Session session;
  final ClientUiController uiController;
  InputManager inputManager;

  Renderer(this._canvas, this.uiController, this.session)
      : _ctx = _canvas.getContext('2d') as CanvasRenderingContext2D {
    for (SoftObjectType type in SoftObjectType.values) {
      softImages[type] = ImageElement();
      softImages[type].src = '/$type.png';
    }
    for (SolidObjectType type in SolidObjectType.values) {
      solidImages[type] = ImageElement();
      solidImages[type].src = '/$type.png';
    }
    for (TileType type in TileType.values) {
      tileImages[type] = ImageElement();
      tileImages[type].src = '/$type.png';
    }

    initializeUi();
  }

  void render(ClientWorld world) {
    _ctx.setTransform(1, 0, 0, 1, 0, 0);
    _ctx.clearRect(0, 0, _canvas.width, _canvas.height);
    if (session.loggedIn == false) {
      return;
    }

    moveCameraToPlayerPosition(session.player.tilePosition);
    _ctx.scale(scale, scale);
    if (cameraPosition != null) {
      _ctx.translate(cameraPosition.x, cameraPosition.y);
    }

    final Box renderingBox = Box(
      session.player.box.left - ((_canvas.width / 2) * (1 / scale)).toInt(),
      session.player.box.top - ((_canvas.height / 2) * (1 / scale)).toInt(),
      ((_canvas.width) * (1 / scale)).toInt(),
      ((_canvas.height) * (1 / scale)).toInt(),
    );

    renderGround(world, renderingBox);
    renderSoftObjects(world, renderingBox);
    renderSolidObjects(world, renderingBox);

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
    if (uiController.draggedItem != null) {
      _ctx.drawImageScaled(softImages[uiController.draggedItem.type],
          inputManager.mousePosition.x, inputManager.mousePosition.y, 40, 40);
    }
  }

  void renderHungerMeter() {
    final HungerUi hunger = uiController.hunger;
    _ctx.fillStyle = 'black';
    fillBox(hunger.box);
    _ctx.fillStyle = 'white';
    _ctx.fillText('Hunger: ${hunger.session.player.hungerComponent.hunger}',
        hunger.box.left + 6, hunger.box.top + 19);
  }

  void renderChat(ClientWorld world) {
    if (uiController.chat.enabled) {
      _ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
      _ctx.fillRect(uiController.chat.box.left, uiController.chat.box.top,
          uiController.chat.box.width, uiController.chat.box.height);
      _ctx.fillStyle = 'white';
      _ctx.fillRect(
          uiController.chat.input.box.left,
          uiController.chat.input.box.top,
          uiController.chat.input.box.width,
          uiController.chat.input.box.height);
      _ctx.fillStyle = 'black';
      _ctx.fillText(
          uiController.chat.input.content,
          uiController.chat.input.box.left + 3,
          uiController.chat.input.box.top + 10);
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
          while (width < uiController.chat.box.width) {
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
        if (height > uiController.chat.box.height) {
          break;
        }
      }
      for (int i = lines.length - 1; i > -1; i--) {
        _ctx.fillText(lines[i], uiController.chat.box.left + 3,
            uiController.chat.input.box.top - 15 * i - 5);
      }
    }
  }

  void renderInventoryMenus(ClientWorld world) {
    for (EntityInventoryMenu inventory in uiController.inventoryMenus) {
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
  }

  void renderCookingMenu() {
    final CookingMenu cookingMenu = uiController.cookingMenu;
    if (cookingMenu.visible) {
      _ctx.fillStyle = 'black';
      _ctx.fillRect(cookingMenu.box.left, cookingMenu.box.top,
          cookingMenu.box.width, cookingMenu.box.height);

      for (int i = 0; i < cookingMenu.buttons.length; i++) {
        final button = cookingMenu.buttons[i];
        _ctx.drawImageScaled(softImages[button.objectType], button.box.left,
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

  void renderBuildMenu(World world) {
    final buildMenu = uiController.buildMenu;
    if (buildMenu.visible) {
      _ctx.fillStyle = 'black';
      _ctx.fillRect(buildMenu.box.left, buildMenu.box.top, buildMenu.box.width,
          buildMenu.box.height);

      for (int i = 0; i < buildMenu.buttons.length; i++) {
        final button = buildMenu.buttons[i];
        _ctx.drawImageScaled(solidImages[button.type], button.box.left,
            button.box.top, button.box.width, button.box.height);
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

  void renderCraftingInventory(World world) {
    final inventory = uiController.craftingInventory;
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
  }

  void renderPlayerInventory(ClientWorld world) {
    if (session.player != null) {
      uiController.inventory.update();
      _ctx.fillStyle = 'black';
      _ctx.fillRect(
          uiController.inventory.box.left,
          uiController.inventory.box.top,
          uiController.inventory.box.width,
          uiController.inventory.box.height);
      for (var i = 0; i < uiController.inventory.buttons.length; i++) {
        final InventoryButton button = uiController.inventory.buttons[i];
        final int itemId = button.itemId;
        final SoftObject item = world.getSoftObject(itemId);
        _ctx.drawImageScaled(softImages[item.type], button.box.left,
            button.box.top, button.box.width, button.box.height);
      }
    }
  }

  void renderCookButton() {
    _ctx.fillStyle = 'black';
    fillBox(uiController.cookButton.box);
    _ctx.fillStyle = 'white';
    _ctx.font = '12px gameFont';
    _ctx.fillText('Cook', uiController.cookButton.box.left + 28,
        uiController.cookButton.box.top + 19);
  }

  void renderBuildButton() {
    _ctx.fillStyle = 'black';
    fillBox(uiController.buildButton.box);
    _ctx.fillStyle = 'white';
    _ctx.font = '12px gameFont';
    _ctx.fillText('Build', uiController.buildButton.box.left + 28,
        uiController.buildButton.box.top + 19);
  }

  void renderSolidObjects(ClientWorld world, Box renderingBox) {
    for (SolidObject object in world.solidObjects) {
      if (object != null &&
          object.box.left < renderingBox.right &&
          object.box.right > renderingBox.left &&
          object.box.bottom > renderingBox.top &&
          object.box.top < renderingBox.bottom) {
        _ctx.drawImageScaled(solidImages[object.type], object.box.left,
            object.box.top, object.box.width, object.box.height);
      }
    }
  }

  void increaseScale(double increase) {
    scale += increase;
    if (scale < 0.05) {
      scale = 0.05;
    }
    moveCameraToPlayerPosition(session.player.tilePosition);
  }

  CanvasPosition getCursorPositionInCanvas(MouseEvent event) {
    final rect = _canvas.getBoundingClientRect();
    final double x = event.client.x - rect.left;
    final double y = event.client.y - rect.top;
    return CanvasPosition(x, y);
  }

  WorldPosition getWorldPositionFromCanvasPosition(CanvasPosition position) {
    return WorldPosition((position.x * (1 / scale)) - cameraPosition.x,
        (position.y * (1 / scale)) - cameraPosition.y);
  }

  WorldPosition getCursorPositionInWorld(MouseEvent event) {
    final CanvasPosition canvasPosition = getCursorPositionInCanvas(event);
    return getWorldPositionFromCanvasPosition(canvasPosition);
  }

  void moveCameraToPlayerPosition(TilePosition tilePosition) {
    final double inverseScale = 1 / scale;
    final double x = -tilePosition.x * tileSize * 1.0 - tileSize / 2;
    final double y = -tilePosition.y * tileSize * 1.0 - tileSize / 2;
    final double canvasMiddleWidth = _canvas.width / 2.0;
    final double canvasMiddleHeight = _canvas.height / 2.0;

    final double translateX = x + canvasMiddleWidth * inverseScale;
    final double translateY = y + canvasMiddleHeight * inverseScale;
    cameraPosition = CanvasPosition(translateX, translateY);
  }

  void initializeUi() {
    final int screenWidth = window.innerWidth - 10;
    final int screenHeight = window.innerHeight - 10;
    _canvas.width = screenWidth;
    _canvas.height = screenHeight;
    print('Window width: $screenWidth, window height: $screenHeight');
    uiController.initialize(screenWidth, screenHeight);
  }

  void fillBox(Box box) {
    _ctx.fillRect(box.left, box.top, box.width, box.height);
  }

  void renderGround(ClientWorld world, Box renderingBox) {
    for (int x = 0; x < worldSize.x; x++) {
      for (int y = 0; y < worldSize.y; y++) {
        final tile = world.tilesColumn[x][y];
        if (tile.box.left < renderingBox.right &&
            tile.box.right > renderingBox.left &&
            tile.box.bottom > renderingBox.top &&
            tile.box.top < renderingBox.bottom) {
          _ctx.drawImageScaled(tileImages[tile.tileType], tile.box.left,
              tile.box.top, tile.box.width, tile.box.height);
        }
      }
    }
  }

  void renderSoftObjects(ClientWorld world, Box renderingBox) {
    for (SoftObject object in world.softObjects) {
      if (object != null && object.position != null) {
        _ctx.drawImageScaled(softImages[object.type], object.position.x,
            object.position.y, 20, 20);
      }
    }
  }

  bool imageIsTransparent(
      ImageElement image, int x, int y, Box box) {
    final CanvasElement imgCanvas = document.getElementById('fake-canvas');
    final CanvasRenderingContext2D ctx = imgCanvas.getContext('2d');
    imgCanvas.width = image.width;
    imgCanvas.height = image.height;
    ctx.drawImageScaled(image, 0, 0, box.width, box.height);
    final data = ctx.getImageData(x, y, 1, 1).data;
    final int pixelTransparency = data[3];
    return pixelTransparency < 40;
  }
}
