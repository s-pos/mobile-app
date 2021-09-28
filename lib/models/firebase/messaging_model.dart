import 'package:json_annotation/json_annotation.dart';

part 'messaging_model.g.dart';

@JsonSerializable()
class FirebaseMessagingModel {
  @JsonKey(name: "url")
  final String? url;

  @JsonKey(name: "type")
  final String? type;

  FirebaseMessagingModel({
    required this.url,
    required this.type,
  });

  factory FirebaseMessagingModel.fromJson(Map<String, dynamic> json) =>
      _$FirebaseMessagingModelFromJson(json);
}
