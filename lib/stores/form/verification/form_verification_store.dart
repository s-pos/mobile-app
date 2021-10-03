import 'package:mobx/mobx.dart';

part 'form_verification_store.g.dart';

class FormVerificationStore = _FormVerificationStore
    with _$FormVerificationStore;

abstract class _FormVerificationStore with Store {
  _FormVerificationStore();

  // all variables will be here
  @observable
  String otp = "";

  @computed
  bool get canVerification => otp.isNotEmpty && otp.length == 6;

  @action
  void setOtp(String value) {
    if (value == "-1") {
      if (otp.isNotEmpty) {
        otp = otp.substring(0, otp.length - 1);
      }
    } else if (value.length == 1) {
      if (otp.length == 6) {
        return;
      }
      // check if set string length is 1 (manual input)
      otp = otp + value;
    } else if (value.length == 6) {
      otp = value;
    }
  }
}
