import 'package:dart_game/common/box.dart';

class Input {
  Box box = Box(0, 0, 0, 0);
  bool active = false;
  String content = '';

  void type(String key) {
    content += key;
  }
}