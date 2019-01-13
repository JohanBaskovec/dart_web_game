import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(anyMap: true)
class Message {
  int senderId;
  String message;

  Message(this.senderId, this.message);

  /// Creates a new [Message] from a JSON object.
  static Message fromJson(Map<dynamic, dynamic> json) => _$MessageFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}