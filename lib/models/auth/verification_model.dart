import 'package:json_annotation/json_annotation.dart';

part 'verification_model.g.dart';

class VerificationModel {
  final String? data;

  VerificationModel({required this.data});

  factory VerificationModel.fromString(String data) =>
      VerificationModel(data: data);
}

@JsonSerializable()
class VerificationRequestModel {
  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "otp")
  final String otp;

  VerificationRequestModel({required this.email, required this.otp});

  Map<String, dynamic> toJson() => _$VerificationRequestModelToJson(this);
}
