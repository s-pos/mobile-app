import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'form_register_store.g.dart';

class FormRegisterStore = _FormRegisterStore with _$FormRegisterStore;

abstract class _FormRegisterStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;

  // form error login for handling error
  final FormRegisterErrorStore formError = FormRegisterErrorStore();

  _FormRegisterStore() {
    setupValidators();
  }

  void setupValidators() {
    _disposers = [
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword),
      reaction((_) => phone, validatePhoneNumber),
      reaction((_) => name, validateName),
    ];
  }

  // variables for form register will be here
  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  String phone = "";

  @observable
  String name = "";

  @computed
  bool get success =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      phone.isNotEmpty &&
      name.isNotEmpty;

  @computed
  bool get canRegister => !formError.hasError && success;

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

  void dispose() {
    for (final d in _disposers) {
      d();
    }
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
