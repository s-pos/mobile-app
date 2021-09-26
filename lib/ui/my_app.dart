import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/app_config.dart';
import 'package:spos/constants/app_theme.dart';
import 'package:spos/data/repository.dart';
import 'package:spos/data/sharedpref/shared_preferences_helper.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/routes/routes.dart';
import 'package:spos/stores/language/language_store.dart';
import 'package:spos/stores/user/user_store.dart';
import 'package:spos/ui/auth/login/login_screen.dart';
import 'package:spos/ui/onboard/onboard_screen.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // create store
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final UserStore _userStore =
      UserStore(getIt<Repository>(), getIt<SharedPreferencesHelper>());

  @override
  Widget build(BuildContext context) {
    String appTitle = AppConfig.of(context)!.appTitle;

    return MultiProvider(
      providers: [
        Provider(create: (_) => _languageStore),
        Provider(create: (_) => _userStore),
      ],
      child: Observer(
        name: "global-observer",
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: appTitle,
            theme: themeData,
            routes: Routes.routes,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale!, language.code))
                .toList(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: _userStore.firstInstall
                ? const LoginScreen()
                : const OnBoardingScreen(),
          );
        },
      ),
    );
  }
}
