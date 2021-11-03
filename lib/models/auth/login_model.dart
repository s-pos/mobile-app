import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  @JsonKey(name: "token_type")
  final String? tokenType;

  @JsonKey(name: "access_token")
  final String? accessToken;

  LoginModel({this.tokenType, this.accessToken});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
