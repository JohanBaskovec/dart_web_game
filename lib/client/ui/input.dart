import 'package:dart_game/common/box.dart';

class Input {
  Box box = Box(left: 0, top:  0, width:  0, height:  0);
  bool active = false;
  String content = '';

  void type(String key) {
    content += key;
  }
}