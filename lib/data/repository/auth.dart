import 'package:spos/data/network/apis/auth/login.dart';
import 'package:spos/data/network/apis/auth/register.dart';
import 'package:spos/models/auth/login_model.dart';
import 'package:spos/models/auth/register_model.dart';

/// RepositoryAuth
/// kumpulan-kumpulan repository untuk melakukan request ke service backend auth
class RepositoryAuth {
  // api login
  final ApiLogin _apiLogin;
  // api register
  final ApiRegister _apiRegister;

  // constructor
  RepositoryAuth(this._apiLogin, this._apiRegister);

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
}
