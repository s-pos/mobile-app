import 'package:spos/data/sharedpref/shared_preferences_helper.dart';

class Repository {
  final SharedPreferencesHelper _sharedPreferencesHelper;

  Repository(this._sharedPreferencesHelper);

  Future<void> changeLanguage(String value) =>
      _sharedPreferencesHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPreferencesHelper.currentLanguage;
}
