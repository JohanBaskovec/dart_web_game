enum CommandType {
  Login,
  LoggedIn,
  AddPlayer,
  RemovePlayer,
  Move,
  Unknown
}

CommandType commandTypeFromString(String name) {
  switch (name) {
    case 'Login':
      return CommandType.Login;
    case 'AddPlayer':
      return CommandType.AddPlayer;
    case 'Move':
      return CommandType.Move;
    case 'LoggedIn':
      return CommandType.LoggedIn;
    case 'RemovePlayer':
      return CommandType.RemovePlayer;
  }
  return CommandType.Unknown;
}

class Command {
  CommandType type;

  Command(this.type);
}