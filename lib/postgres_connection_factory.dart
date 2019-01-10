import 'package:postgres/postgres.dart';

class PostgresConnectionFactory {
  String _host;
  int _port;
  String _name;
  String _username;
  String _password;

  PostgresConnectionFactory(
      this._host, this._port, this._name, this._username, this._password)
      : assert(_host != null),
        assert(_port != null),
        assert(_name != null),
        assert(_username != null),
        assert(_password != null);

  Future<PostgreSQLConnection> newOpenConnection() async {
    final connection = PostgreSQLConnection(_host, _port, _name,
        username: _username, password: _password);
    await connection.open();
    return connection;
  }
}
