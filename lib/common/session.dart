import 'package:dart_game/common/entity.dart';

class Session {
  String username;
  String password;
  bool loggedIn = false;
  Entity player;

  Session(this.player, this.username);

  @override
  String toString() {
    return 'Session{username: $username, password: $password, loggedIn: $loggedIn, player: $player}';
  }
}

Session currentSession;
