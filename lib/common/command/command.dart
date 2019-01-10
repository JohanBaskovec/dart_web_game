enum CommandType {
  login,
  loggedIn,
  addPlayer,
  removePlayer,
  move,
  unknown
}

CommandType commandTypeFromString(String name) {
  switch (name) {
    case 'login':
      return CommandType.login;
    case 'addPlayer':
      return CommandType.addPlayer;
    case 'move':
      return CommandType.move;
    case 'loggedIn':
      return CommandType.loggedIn;
    case 'removePlayer':
      return CommandType.removePlayer;
  }
  return CommandType.unknown;
}

class Command {
  CommandType type;

  Command(this.type);
}