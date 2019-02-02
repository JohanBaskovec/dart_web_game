import 'package:dart_game/common/entity.dart';
import 'package:dart_game/common/identifiable.dart';
import 'package:dart_game/common/game_objects/world.dart' as world;

abstract class Component extends GameObject {
  int entityAreaId;
  int entityId;

  Component({int id, int areaId, this.entityId, this.entityAreaId})
      : super(id: id, areaId: areaId);

  Entity get entity => world.entities[entityAreaId][entityId];
}
