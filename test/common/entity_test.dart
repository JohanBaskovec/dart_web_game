import 'package:dart_game/common/entity.dart';
import 'package:test/test.dart';

void main() {
  group('Serialization', () {
    test('should work', () {
      final entity = Entity(
          renderingComponentId: 1, healthComponentId: 2, inventoryComponentId: 3);
      final byteData = entity.toByteData();
      final entity2 = Entity.fromByteData(byteData);
      expect(entity2.renderingComponentId, equals(1));
      expect(entity2.healthComponentId, equals(2));
      expect(entity2.inventoryComponentId, equals(3));
    });
  });
}