import 'package:mobx/mobx.dart';
import 'package:spos/data/repository.dart';
import 'package:spos/models/language/language.dart';
import 'package:spos/stores/error/error_store.dart';

part 'language_store.g.dart';

class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  static const String TAG = "LanguageStore";

  // repository instance
  final Repository _repository;

  final ErrorStore errorStore = ErrorStore();

  _LanguageStore(Repository repository) : _repository = repository {
    init();
  }

  List<Language> supportedLanguages = [
    Language(code: "ID", locale: "id", language: "Indonesia"),
  ];

  // store variables
  @observable
  String _locale = "id";

  @computed
  String get locale => _locale;

  // language store actions will be here
  @action
  void changeLanguage(String value) {
    _locale = value;
    _repository.changeLanguage(value);
  }

  @action
  String getCode() {
    String code;
    switch (_locale) {
      default:
        code = "ID";
        break;
    }

    return code;
  }

  @action
  String? getLanguage() {
    return supportedLanguages[supportedLanguages.indexWhere(
      (language) => language.locale == _locale,
    )]
        .language;
  }

  // general function
  void init() async {
    if (_repository.currentLanguage != null) {
      _locale = _repository.currentLanguage!;
    } else {
      _locale = "ID";
    }
  }

  dispose() {}
}
