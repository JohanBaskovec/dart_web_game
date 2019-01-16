import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(anyMap: true)
class Message {
  String senderName;
  String message;

  Message(this.senderName, this.message);

  /// Creates a new [Message] from a JSON object.
  static Message fromJson(Map<dynamic, dynamic> json) => _$MessageFromJson(json);

  /// Convert this object to a JSON object.
  @override
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}