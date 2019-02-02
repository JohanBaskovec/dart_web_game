import 'package:dart_game/common/serializable.dart';

abstract class GameObject implements Serializable {
  int id;
  int areaId;

  GameObject({this.id, this.areaId});
}