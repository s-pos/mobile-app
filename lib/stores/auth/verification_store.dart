import 'package:mobx/mobx.dart';
import 'package:spos/stores/error/error_store.dart';

part 'verification_store.g.dart';

class VerificationStore = _VerificationStore with _$VerificationStore;

abstract class _VerificationStore with Store {
  // disposers
  late List<ReactionDisposer> _disposers;

  // store for error handling
  final ErrorStore errorStore = ErrorStore();

  // all variables will be here
}
