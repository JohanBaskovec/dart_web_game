enum CommandType {
  Login,
  AddPlayer,
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
  }
  return CommandType.Unknown;
}

class Command {
  CommandType type;

  Command(this.type);
}