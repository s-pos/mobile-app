import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

class RegisterModel {
  @JsonKey(name: "data")
  final String? data;

  RegisterModel({this.data});

  factory RegisterModel.fromString(String res) => RegisterModel(data: res);
}

@JsonSerializable()
class RegisterRequestModel {
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "phone_number")
  final String? phone;
  @JsonKey(name: "name")
  final String? name;

  RegisterRequestModel({
    this.email,
    this.password,
    this.phone,
    this.name,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
