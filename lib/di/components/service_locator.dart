import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spos/data/firebase/remote_config_helper.dart';
import 'package:spos/data/network/apis/auth/login.dart';
import 'package:spos/data/network/dio_client.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/data/repository/firebase.dart';
import 'package:spos/data/repository/repository.dart';
import 'package:spos/data/sharedpref/shared_preferences_helper.dart';
import 'package:spos/di/module/firebase_module.dart';
import 'package:spos/di/module/local_module.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/di/module/network_module.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/stores/form/login/form_login_store.dart';

final getIt = GetIt.instance;

Future<void> setupLocator(String env) async {
  // first time registering route navigation
  getIt.registerLazySingleton(() => NavigationModule());
  // list factory no needed parameters
  // factory error store handler
  getIt.registerFactory(() => ErrorStore());
  // factory form login
  getIt.registerFactory(() => FormLoginStore());

  // async singleton
  // this is will register dependencies
  // shared preferences module
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());
  // firebase module
  // init firebase core
  getIt
      .registerSingletonAsync<FirebaseApp>(() => FirebaseModule.initFirebase());
  // init for remote config
  getIt.registerSingletonAsync<RemoteConfig>(
    () => FirebaseModule.provideRemoteConfig(getIt.getAsync<FirebaseApp>()),
  );

  // singleton without async
  // register shared preferences helpers with parameters SharedPreferences
  // we register before
  getIt.registerSingleton<SharedPreferencesHelper>(
      SharedPreferencesHelper(await getIt.getAsync<SharedPreferences>()));
  // register helper firebase remote_config
  getIt.registerSingleton<RemoteConfigHelper>(
    RemoteConfigHelper(
      await getIt.getAsync<RemoteConfig>(),
    ),
  );
  // registering dio for the first time with custom options
  // and parameters shared preferences helpers we register before
  getIt.registerSingleton(
    NetworkModule.provideDio(
      env,
      getIt<SharedPreferencesHelper>(),
      getIt<RemoteConfigHelper>(),
    ),
  );
  // registering default http request for method
  // GET, POST
  // with parameters dio we register before
  getIt.registerSingleton(DioClient(getIt<Dio>()));

  // registering default channel notification for android
  getIt.registerSingleton<AndroidNotificationChannel>(
    LocalModule.provideAndroidNotificationChannel(),
  );
  // registering plugin for local notifications (ios and android)
  getIt.registerSingletonAsync<FlutterLocalNotificationsPlugin>(
    () => LocalModule.provideLocalNotificationsPlugin(
      getIt<AndroidNotificationChannel>(),
    ),
  );

  // list api register will be here
  getIt.registerSingleton(ApiLogin(getIt<DioClient>()));

  // register repository
  getIt.registerSingleton(Repository(getIt<SharedPreferencesHelper>()));
  // register auth repository
  getIt.registerSingleton(RepositoryAuth(getIt<ApiLogin>()));
  // register firebase repository
  getIt.registerSingleton(FirebaseRepository(getIt<RemoteConfigHelper>()));
}
