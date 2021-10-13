import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/models/auth/verification_model.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/utils/dio/dio_error_utils.dart';

part 'verification_store.g.dart';

class VerificationStore = _VerificationStore with _$VerificationStore;

abstract class _VerificationStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;

  // all models will be here
  late VerificationModel? res;

  // repository
  final RepositoryAuth _auth;

  // store for error handling
  final ErrorStore errorStore = ErrorStore();

  // constructor
  _VerificationStore(RepositoryAuth repositoryAuth) : _auth = repositoryAuth {
    setupValidation();
  }

  // setupValidation
  void setupValidation() {
    _disposers = [
      reaction((p0) => res, (_) => res = null, delay: 200),
      reaction((p0) => success, (_) => success = false, delay: 200),
    ];
  }

  // all variables will be here
  @observable
  bool success = false;

  static ObservableFuture<VerificationModel?> emptyResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<VerificationModel?> verificationFuture =
      ObservableFuture<VerificationModel?>(emptyResponse);

  @computed
  bool get loading => verificationFuture.status == FutureStatus.pending;

  // list all action will be here
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
