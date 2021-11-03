import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/models/auth/login_model.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/stores/user/user_store.dart';
import 'package:spos/utils/dio/dio_error_utils.dart';
import 'package:validators/validators.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;
  // store for handling error validating
  final FormLoginErrorStore formError = FormLoginErrorStore();

  // store management
  // User store
  final UserStore _userStore;
  // Error store for handling error
  final ErrorStore errorStore = ErrorStore();

  // repository auth
  final RepositoryAuth _auth;

  _LoginStore(RepositoryAuth repositoryAuth, UserStore userStore)
      : _auth = repositoryAuth,
        _userStore = userStore {
    _setupValidations();
  }

  void _setupValidations() {
    _disposers = [
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword),
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // Form Login Store variables will be here
  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  bool success = false;

  @computed
  bool get canLogin =>
      !formError.hasError && email.isNotEmpty && password.isNotEmpty;

  static ObservableFuture<LoginModel?> emptyLoginResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<LoginModel?> loginFuture =
      ObservableFuture<LoginModel?>(emptyLoginResponse);

  @computed
  bool get loading => loginFuture.status == FutureStatus.pending;

  @computed
  String? get token => _userStore.token;

  // form login actions will be here
  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void validateEmail(String value) {
    if (value.isEmpty) {
      formError.email = "login_error_email_empty";
    } else if (!isEmail(value)) {
      formError.email = "login_error_email_invalid";
    } else {
      formError.email = null;
    }
  }

  @action
  void validatePassword(String value) {
    if (value.isEmpty) {
      formError.password = "login_error_password_empty";
    } else if (value.length < 6) {
      formError.password = "login_error_min_char";
    } else {
      formError.password = null;
    }
  }

  @action
  void removeToken() {
    _userStore.resetToken();
  }

  // Login store actions will be here
  @action
  Future doLogin(String email, String password) async {
    success = false;

    final future = _auth.postLogin(email, password);
    loginFuture = ObservableFuture(future);

    await future.then((res) async {
      success = true;
      String token = "${res.tokenType} ${res.accessToken}";
      // will store to share preferences
      _userStore.setToken(token);
    }).catchError((error) {
      success = false;
      Map<String, dynamic> err = DioErrorUtil.handleError(error);
      errorStore.errorMessage = err["reason"];
    });
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validateEmail(email);
    validatePassword(password);
  }
}

class FormLoginErrorStore = _FormLoginErrorStore with _$FormLoginErrorStore;

abstract class _FormLoginErrorStore with Store {
  // variables error will be here
  @observable
  String? email;

  @observable
  String? password;

  @computed
  bool get hasError => email != null || password != null;
}
