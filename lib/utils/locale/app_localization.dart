import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> localizedStrings;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }

  // method that will load local specific strings from file
  // present in assets/lang folder
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    localizedStrings = jsonMap.map(
      (key, value) => MapEntry(
        key,
        value.toString().replaceAll(r"\'", "'").replaceAll(r"\t", " "),
      ),
    );

    return true;
  }

  String translate(String key) {
    return localizedStrings[key]!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final String TAG = "AppLocalizations";

  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["id"].contains(
      locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
