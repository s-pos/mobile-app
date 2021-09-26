import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalModule {
  // singleton shared preferences
  static Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }
}
