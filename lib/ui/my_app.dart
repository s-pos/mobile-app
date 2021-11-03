import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/app_config.dart';
import 'package:spos/constants/app_theme.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/data/repository/repository.dart';
import 'package:spos/data/sharedpref/shared_preferences_helper.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/routes/routes.dart';
import 'package:spos/stores/auth/login/login_store.dart';
import 'package:spos/stores/auth/register/register_store.dart';
import 'package:spos/stores/language/language_store.dart';
import 'package:spos/stores/user/user_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // create store
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final UserStore _userStore =
      UserStore(getIt<Repository>(), getIt<SharedPreferencesHelper>());
  final RegisterStore _registerStore = RegisterStore(getIt<RepositoryAuth>());
  final LoginStore _loginStore =
      LoginStore(getIt<RepositoryAuth>(), getIt<UserStore>());

  @override
  Widget build(BuildContext context) {
    String appTitle = AppConfig.of(context)!.appTitle;

    return MultiProvider(
      providers: [
        Provider(create: (_) => _languageStore),
        Provider(create: (_) => _userStore),
        Provider(create: (_) => _registerStore),
        Provider(create: (_) => _loginStore)
      ],
      child: Observer(
        name: "global-observer",
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: appTitle,
            theme: themeData,
            navigatorKey: getIt<NavigationModule>().navigatorKey,
            onGenerateRoute: Routes.routes,
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
            initialRoute:
                _userStore.firstInstall ? Routes.login : Routes.onBoard,
          );
        },
      ),
    );
  }
}
