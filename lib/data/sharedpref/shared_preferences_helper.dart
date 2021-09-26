import 'package:shared_preferences/shared_preferences.dart';
import 'package:spos/data/sharedpref/constants/preferences.dart';

class SharedPreferencesHelper {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesHelper(this._sharedPreferences);

  // getter for token authorization
  Future<String?> get token async {
    return _sharedPreferences.getString(PreferencesConst.token);
  }

  // setter token authorization
  Future<bool> setToken(String token) async {
    return _sharedPreferences.setString(PreferencesConst.token, token);
  }

  // remove token when user logout
  Future<bool> removeToken() async {
    return _sharedPreferences.remove(PreferencesConst.token);
  }

  // getter for user firstInstall or not and will skip on_boarding page
  Future<bool?> get firstInstall async {
    return _sharedPreferences.getBool(PreferencesConst.firstLogin);
  }

  // setter for user firstInstall
  Future<bool> setFirstInstall(bool value) async {
    return _sharedPreferences.setBool(PreferencesConst.firstLogin, value);
  }

  // getter for skip on_boarding page and login page
  Future<bool?> get isLoggedIn async {
    return _sharedPreferences.getBool(PreferencesConst.isLoggedIn);
  }

  // setter user login after user success login
  Future<bool> setIsLoggedIn(bool value) async {
    return _sharedPreferences.setBool(PreferencesConst.isLoggedIn, value);
  }

  // language preferences
  // getter for get currentLanguage
  String? get currentLanguage =>
      _sharedPreferences.getString(PreferencesConst.currentLanguage);

  // setter for changing language apps
  Future<void> changeLanguage(String language) {
    return _sharedPreferences.setString(
        PreferencesConst.currentLanguage, language);
  }
}
