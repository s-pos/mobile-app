import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/models/auth/verification_model.dart';
import 'package:spos/routes/routes.dart';
import 'package:spos/stores/auth/verification_store.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/utils/dio/dio_error_utils.dart';

part 'verification_store.g.dart';

class VerificationStore = _VerificationStore with _$VerificationStore;

abstract class _VerificationStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;

  // verification store
  final String email;

  // all models will be here
  late VerificationModel? res;

  // repository
  final RepositoryAuth _auth;

  // store for error handling
  final ErrorStore errorStore = ErrorStore();

  final NavigationModule navigation = getIt<NavigationModule>();

  _VerificationStore(RepositoryAuth repositoryAuth, this.email)
      : _auth = repositoryAuth;

  void setupValidation() {
    _disposers = [
      reaction((_) => otp, (_) => otp = "", delay: 200),
      reaction((_) => res, (_) => res = null, delay: 200),
    ];
  }

  // all variables will be here
  @observable
  String otp = "";

  @observable
  bool success = false;

  @computed
  bool get canVerification => otp.isNotEmpty && otp.length == 6;

  static ObservableFuture<VerificationModel?> emptyResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<VerificationModel?> verificationFuture =
      ObservableFuture<VerificationModel?>(emptyResponse);

  @computed
  bool get loading => verificationFuture.status == FutureStatus.pending;

  // all action will be here
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
    await _verificationStore.otpRegister(email, otp);

    if (_verificationStore.success) {
      Fluttertoast.showToast(
          msg: _verificationStore.res!.data!, gravity: ToastGravity.TOP);
      navigation.navigateTo(Routes.login);
    } else {
      Fluttertoast.showToast(msg: _verificationStore.errorStore.errorMessage);
    }
  }

  @action
  Future<VerificationModel?> otpRegister(String email, String otp) async {
    success = false;
    final VerificationRequestModel req =
        VerificationRequestModel(email: email, otp: otp);

    final future = _auth.postVerificationRegister(req.toJson());
    verificationFuture = ObservableFuture(future);

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
}
