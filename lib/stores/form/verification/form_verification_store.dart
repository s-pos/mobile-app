import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/models/auth/verification_model.dart';
import 'package:spos/stores/auth/verification_store.dart';

part 'form_verification_store.g.dart';

class FormVerificationStore = _FormVerificationStore
    with _$FormVerificationStore;

abstract class _FormVerificationStore with Store {
  // verification store
  final VerificationStore _verificationStore;
  final String email;

  _FormVerificationStore(VerificationStore verificationStore, this.email)
      : _verificationStore = verificationStore;

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
        autoRequestVerification();
        return;
      }
      // check if set string length is 1 (manual input)
      otp = otp + value;
      if (otp.length == 6) {
        autoRequestVerification();
      }
    } else if (value.length == 6) {
      otp = value;
      autoRequestVerification();
    }
  }

  @action
  Future<void> autoRequestVerification() async {
    final VerificationModel? res =
        await _verificationStore.otpRegister(email, otp);

    if (_verificationStore.success) {
      Fluttertoast.showToast(msg: res!.data!);
    } else {
      Fluttertoast.showToast(msg: _verificationStore.errorStore.errorMessage);
    }
  }
}
