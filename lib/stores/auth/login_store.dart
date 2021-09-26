import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/models/auth/login_model.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/stores/user/user_store.dart';
import 'package:spos/utils/dio/dio_error_utils.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;

  // store management
  // User store
  final UserStore _userStore;
  // Error store for handling error
  final ErrorStore errorStore = ErrorStore();

  // repository auth
  final RepositoryAuth _auth;

  // constructor
  _LoginStore(RepositoryAuth auth, UserStore userStore)
      : _auth = auth,
        _userStore = userStore {
    _setupDisposers();
  }

  void _setupDisposers() {
    _disposers = [
      reaction((p0) => success, (_) => success = false, delay: 200),
    ];
  }

  // Login store variables will be here
  @observable
  bool success = false;

  static ObservableFuture<LoginModel?> emptyLoginResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<LoginModel?> loginFuture =
      ObservableFuture<LoginModel?>(emptyLoginResponse);

  @computed
  bool get loading => loginFuture.status == FutureStatus.pending;

  // Login store actions will be here
  Future doLogin(String email, String password) async {
    success = false;

    final future = _auth.postLogin(email, password);
    loginFuture = ObservableFuture(future);

    await future.then((res) {
      success = true;
      // will store to share preferences
      _userStore.setToken("${res.tokenType} ${res.accessToken}");
    }).catchError((error) {
      success = false;
      Map<String, dynamic> err = DioErrorUtil.handleError(error);
      errorStore.errorMessage = err["reason"];
    });
  }

  // general
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
