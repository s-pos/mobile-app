import 'package:spos/data/network/apis/auth/login.dart';
import 'package:spos/data/network/apis/auth/register.dart';
import 'package:spos/data/network/apis/auth/verification.dart';
import 'package:spos/models/auth/login_model.dart';
import 'package:spos/models/auth/register_model.dart';
import 'package:spos/models/auth/verification_model.dart';

/// RepositoryAuth
/// kumpulan-kumpulan repository untuk melakukan request ke service backend auth
class RepositoryAuth {
  // api login
  final ApiLogin _apiLogin;
  // api register
  final ApiRegister _apiRegister;
  // api verification
  final ApiVerification _apiVerification;

  // constructor
  RepositoryAuth(this._apiLogin, this._apiRegister, this._apiVerification);

  // return LoginModel
  Future<LoginModel> postLogin(String email, String password) async {
    return await _apiLogin
        .login(email, password)
        .then((response) => response)
        .catchError((error) => throw error);
  }

  Future<RegisterModel> postRegister(Map<String, dynamic> data) async {
    return await _apiRegister
        .register(data)
        .then((value) => value)
        .catchError((err) => throw err);
  }

  Future<VerificationModel> postVerificationRegister(
      Map<String, dynamic> data) async {
    return await _apiVerification
        .verificationRegister(data)
        .then((res) => res)
        .catchError((err) => throw err);
  }
}
