import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/models/auth/register_model.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/utils/dio/dio_error_utils.dart';
import 'package:validators/validators.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStore with _$RegisterStore;

abstract class _RegisterStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;

  // register model
  late RegisterModel? res;

  // store for handling error
  final ErrorStore errorStore = ErrorStore();

  // repository authentications
  final RepositoryAuth _auth;

  // form error login for handling error
  final FormRegisterErrorStore formError = FormRegisterErrorStore();

  _RegisterStore(RepositoryAuth repositoryAuth) : _auth = repositoryAuth {
    setupValidators();
  }

  void setupValidators() {
    _disposers = [
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword),
      reaction((_) => phone, validatePhoneNumber),
      reaction((_) => name, validateName),
      reaction((_) => res, (_) => res = null, delay: 200),
    ];
  }

  // variables for form register will be here
  @observable
  bool success = false;

  static ObservableFuture<RegisterModel?> emptyResponseRegister =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<RegisterModel?> registerFuture =
      ObservableFuture<RegisterModel?>(emptyResponseRegister);

  @computed
  bool get loading => registerFuture.status == FutureStatus.pending;

  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  String phone = "";

  @observable
  String name = "";

  @computed
  bool get canRegister =>
      !formError.hasError &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      phone.isNotEmpty &&
      name.isNotEmpty;

  // Action for form register will be here
  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setPhone(String value) {
    phone = value;
  }

  @action
  void setName(String value) {
    name = value;
  }

  @action
  void validateEmail(String value) {
    if (value.isEmpty) {
      formError.email = "register_error_email_empty";
    } else if (!isEmail(value)) {
      formError.email = "register_error_email_invalid";
    } else {
      formError.email = null;
    }
  }

  @action
  void validatePassword(String value) {
    if (value.isEmpty) {
      formError.password = "register_error_password_empty";
    } else if (value.length < 6) {
      formError.password = "register_error_password_min_char";
    } else {
      formError.password = null;
    }
  }

  @action
  void validatePhoneNumber(String value) {
    if (value.isEmpty) {
      formError.phone = "register_error_phone_empty";
    } else if (value.isNotEmpty && value.length < 10) {
      formError.phone = "register_error_phone_min_char";
    } else if (!isNumeric(value)) {
      formError.phone = "register_error_phone_must_number";
    } else {
      formError.phone = null;
    }
  }

  @action
  void validateName(String value) {
    if (value.isEmpty) {
      formError.name = "register_error_name_empty";
    } else {
      formError.name = null;
    }
  }

  @action
  Future<RegisterModel?> register(
    String email,
    String password,
    String phone,
    String name,
  ) async {
    success = false;
    final RegisterRequestModel registerRequest = RegisterRequestModel(
      name: name,
      password: password,
      email: email,
      phone: phone,
    );

    final future = _auth.postRegister(registerRequest.toJson());
    registerFuture = ObservableFuture(future);

    await future.then((data) {
      success = true;
      res = data;
    }).catchError((err) {
      success = false;
      Map<String, dynamic> error = DioErrorUtil.handleError(err);

      errorStore.errorMessage = error["reason"];
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
    validateName(name);
    validatePhoneNumber(phone);
  }
}

class FormRegisterErrorStore = _FormRegisterErrorStore
    with _$FormRegisterErrorStore;

abstract class _FormRegisterErrorStore with Store {
  // variable form login store will be here
  @observable
  String? email;
  @observable
  String? password;
  @observable
  String? name;
  @observable
  String? phone;

  @computed
  bool get hasError =>
      email != null || password != null || name != null || phone != null;
}
