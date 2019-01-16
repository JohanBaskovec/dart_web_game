import 'package:dart_game/common/game_objects/soft_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stack.g.dart';

@JsonSerializable(anyMap: true)
class Stack {
  SoftObjectType objectType;
  List<int> objectsIds = [];

  Stack(this.objectType);

  bool get isEmpty => objectsIds.isEmpty;

  void add(int objectId) {
    objectsIds.add(objectId);
  }

  int removeLast() {
    return objectsIds.removeLast();
  }

  int get length => objectsIds.length;

  void removeRange(int start, int end) => objectsIds.removeRange(start, end);

  int operator [](int index) => objectsIds[index];

  /// Creates a new [Stack] from a JSON object.
  static Stack fromJson(Map<dynamic, dynamic> json) =>
      _$StackFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$StackToJson(this);
}
