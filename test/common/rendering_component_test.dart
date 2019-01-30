import 'package:dart_game/common/box.dart';
import 'package:dart_game/common/rendering_component.dart';
import 'package:test/test.dart';

void main() {
  group('Serialization', () {
    test('should work', () {
      final component = RenderingComponent(box: Box(left: 2, top: 3, width: 4, height: 5), entityId: 11, gridAligned: true);
      final byteData = component.toByteData();
      final component2 = RenderingComponent.fromByteData(byteData);
      expect(component2.box.left, equals(2));
      expect(component2.box.top, equals(3));
      expect(component2.box.width, equals(4));
      expect(component2.box.height, equals(5));
      expect(component2.box.right, equals(6));
      expect(component2.box.bottom, equals(8));
      expect(component2.entityId, equals(11));
      expect(component2.gridAligned, equals(true));
    });
  });
}
