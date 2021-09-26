import 'package:spos/data/network/apis/auth/login.dart';
import 'package:spos/models/auth/login_model.dart';

/// RepositoryAuth
/// kumpulan-kumpulan repository untuk melakukan request ke service backend auth
class RepositoryAuth {
  // api login
  final ApiLogin _apiLogin;

  // constructor
  RepositoryAuth(this._apiLogin);

  // return LoginModel
  Future<LoginModel> postLogin(String email, String password) async {
    return await _apiLogin
        .login(email, password)
        .then((response) => response)
        .catchError((error) => throw error);
  }
}
