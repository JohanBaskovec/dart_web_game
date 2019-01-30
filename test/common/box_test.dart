import 'package:dart_game/common/box.dart';
import 'package:test/test.dart';

void main() {
  group('Serialization', () {
    test('should work', () {
      final box = Box(left: 2, top: 3, width: 4, height: 5);
      final byteData = box.toByteData();
      final box2 = Box.fromByteData(byteData);
      expect(box2.left, equals(2));
      expect(box2.top, equals(3));
      expect(box2.width, equals(4));
      expect(box2.height, equals(5));
      expect(box2.right, equals(6));
      expect(box2.bottom, equals(8));
    });
  });
}
