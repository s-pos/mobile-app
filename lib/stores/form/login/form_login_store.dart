import 'package:mobx/mobx.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:validators/validators.dart';

part 'form_login_store.g.dart';

class FormLoginStore = _FormLoginStore with _$FormLoginStore;

abstract class _FormLoginStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;
  // store for handling error validating
  final FormLoginErrorStore formError = FormLoginErrorStore();

  _FormLoginStore() {
    _setupValidations();
  }

  void _setupValidations() {
    _disposers = [
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword),
    ];
  }

  // Form Login Store variables will be here
  @observable
  String email = "";

  @observable
  String password = "";

  @computed
  bool get success => email.isNotEmpty && password.isNotEmpty;

  @computed
  bool get canLogin => !formError.hasError && success;

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
