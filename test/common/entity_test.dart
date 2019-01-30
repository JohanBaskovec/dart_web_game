import 'package:dart_game/common/entity.dart';
import 'package:test/test.dart';

void main() {
  group('Serialization', () {
    test('should work', () {
      final entity = Entity(
          renderingComponent: 1, healthComponent: 2, inventoryComponent: 3);
      final byteData = entity.toByteData();
      final entity2 = Entity.fromByteData(byteData);
      expect(entity2.renderingComponent, equals(1));
      expect(entity2.healthComponent, equals(2));
      expect(entity2.inventoryComponent, equals(3));
    });
  });
}