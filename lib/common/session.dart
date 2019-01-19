import 'package:dart_game/common/game_objects/solid_object.dart';
import 'package:dart_game/common/game_objects/world.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable(anyMap: true)
class Session {
  int playerId;
  SolidObject get player => world.getSolidObject(playerId);

  String username;
  String password;
  bool loggedIn = false;

  @JsonKey(ignore: true)
  World world;

  Session(this.playerId, this.username, [this.world]);

  /// Creates a new [Session] from a JSON object.
  static Session fromJson(Map<dynamic, dynamic> json) =>
      _$SessionFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  String toString() {
    return 'Session{playerId: $playerId, username: $username, password: $password, world: $world}';
  }
}
