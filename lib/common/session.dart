import 'package:dart_game/common/entity.dart';

class Session {
  int playerId;
  String username;
  String password;
  bool loggedIn = false;
  Entity player;

  Session(this.playerId, this.username);

  @override
  String toString() {
    return 'Session{playerId: $playerId, username: $username, password: $password, loggedIn: $loggedIn, player: $player}';
  }
}
