import 'package:shared_preferences/shared_preferences.dart';
import 'package:spos/data/sharedpref/constants/preferences.dart';

class SharedPreferencesHelper {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesHelper(this._sharedPreferences);

  Future<String?> get token async {
    return _sharedPreferences.getString(PreferencesConst.token);
  }

  Future<bool> setToken(String token) async {
    return _sharedPreferences.setString(PreferencesConst.token, token);
  }

  Future<bool> removeToken() async {
    return _sharedPreferences.remove(PreferencesConst.token);
  }

  Future<bool?> get firstInstall async {
    return _sharedPreferences.getBool(PreferencesConst.firstLogin);
  }

  Future<bool> setFirstInstall(bool value) async {
    return _sharedPreferences.setBool(PreferencesConst.firstLogin, value);
  }

  Future<bool?> get isLoggedIn async {
    return _sharedPreferences.getBool(PreferencesConst.isLoggedIn);
  }

  Future<bool> setIsLoggedIn(bool value) async {
    return _sharedPreferences.setBool(PreferencesConst.isLoggedIn, value);
  }
}
