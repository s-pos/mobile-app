import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/repository.dart';
import 'package:spos/data/sharedpref/shared_preferences_helper.dart';
import 'package:spos/stores/error/error_store.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;
  // repository instance
  final Repository _repository;
  // shared preferences helper instances
  final SharedPreferencesHelper _prefs;
  // store for handling error
  final ErrorStore errorStore = ErrorStore();

  // constructor
  _UserStore(Repository repository, SharedPreferencesHelper sharedPrefsHelper)
      : _repository = repository,
        _prefs = sharedPrefsHelper {
    _setupDisposers();

    _prefs.firstInstall.then(
      (value) => value != null ? firstInstall = value : firstInstall = false,
    );
    _prefs.token.then((value) => token = value);
  }

  void _setupDisposers() {
    _disposers = [
      reaction((_) => firstInstall, resetFirstInstall, delay: 200),
      reaction((_) => token, resetToken, delay: 200),
    ];
  }

  // User store all variables will be here
  bool firstInstall = false;
  String? token;

  // User store actions will be here
  // action for set user already go to page on_board
  // a.k.a firstInstall
  @action
  Future setFirstInstall(bool value) async =>
      await _prefs.setFirstInstall(value);
  // action for save token
  @action
  Future setToken(String value) async => await _prefs.setToken(value);
  // reset first install
  @action
  Future<void> resetFirstInstall(bool value) async =>
      await _prefs.setFirstInstall(false);
  // reset user token
  @action
  Future<void> resetToken(String? value) async => await _prefs.removeToken();

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
