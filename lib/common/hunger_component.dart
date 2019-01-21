import 'package:dart_game/server/server_world.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hunger_component.g.dart';

@JsonSerializable(anyMap: true)
class HungerComponent {
  int hunger;
  int increasePerSecond;
  int ownerId;

  HungerComponent(this.hunger, this.increasePerSecond);

  /// Creates a new [HungerComponent] from a JSON object.
  static HungerComponent fromJson(Map<dynamic, dynamic> json) =>
      _$HungerComponentFromJson(json);

  /// Convert this object to a JSON object.
  Map<String, dynamic> toJson() => _$HungerComponentToJson(this);

  void update(World world) {
    assert(ownerId != null);
    assert(world.solidObjects[ownerId] != null);
    hunger += increasePerSecond;
    if (hunger >= 100) {
      world.solidObjects[ownerId].alive = false;
    }
  }

  @override
  String toString() {
    return 'HungerComponent{hunger: $hunger, increasePerSecond: $increasePerSecond, ownerId: $ownerId}';
  }
}