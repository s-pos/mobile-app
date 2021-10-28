import 'package:mobx/mobx.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/models/auth/register_model.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/utils/dio/dio_error_utils.dart';

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

  _RegisterStore(RepositoryAuth repositoryAuth) : _auth = repositoryAuth {
    setupValidation();
  }

  void setupValidation() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
      reaction((p0) => res, (_) => res = null, delay: 200),
    ];
  }

  // Register store variable will be here
  @observable
  bool success = false;

  static ObservableFuture<RegisterModel?> emptyResponseRegister =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<RegisterModel?> registerFuture =
      ObservableFuture<RegisterModel?>(emptyResponseRegister);

  @computed
  bool get loading => registerFuture.status == FutureStatus.pending;

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

  // Register store action will be here
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
