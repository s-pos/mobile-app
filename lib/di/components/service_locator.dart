import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spos/data/network/dio_client.dart';
import 'package:spos/data/repository.dart';
import 'package:spos/data/sharedpref/shared_preferences_helper.dart';
import 'package:spos/di/module/local_module.dart';
import 'package:spos/di/module/network_module.dart';
import 'package:spos/stores/error/error_store.dart';
import 'package:spos/stores/form/login/form_login_store.dart';

final getIt = GetIt.instance;

Future<void> setupLocator(String env) async {
  // list factory no needed parameters
  // factory error store handler
  getIt.registerFactory(() => ErrorStore());
  // factory form login
  getIt.registerFactory(() => FormLoginStore());

  // async singleton
  // this is will register dependencies
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  // singleton without async
  // register shared preferences helpers with parameters SharedPreferences
  // we register before
  getIt.registerSingleton<SharedPreferencesHelper>(
      SharedPreferencesHelper(await getIt.getAsync<SharedPreferences>()));
  // registering dio for the first time with custom options
  // and parameters shared preferences helpers we register before
  getIt.registerSingleton(
    NetworkModule.provideDio(
      env,
      getIt<SharedPreferencesHelper>(),
    ),
  );
  // registering default http request for method
  // GET, POST
  // with parameters dio we register before
  getIt.registerSingleton(DioClient(getIt<Dio>()));

  // list api register will be here

  // register repository
  getIt.registerSingleton(Repository(getIt<SharedPreferencesHelper>()));
}
