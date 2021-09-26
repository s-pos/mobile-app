import 'package:dio/dio.dart';
import 'package:spos/constants/api_constant.dart';
import 'package:spos/data/sharedpref/shared_preferences_helper.dart';
import 'package:spos/di/constants/di_constant.dart';

abstract class NetworkModule {
  // singleton for dio
  static Dio provideDio(String env, SharedPreferencesHelper _prefs) {
    final dio = Dio();

    dio
      ..options.baseUrl = env == ApiConstant.dev
          ? ApiConstant.baseUrlDev
          : env == ApiConstant.prod
              ? ApiConstant.baseUrlProd
              : "" // let set empty string. because environment not found
      ..options.connectTimeout = ApiConstant.connectionTimeout
      ..options.receiveTimeout = ApiConstant.receivedTimeout
      ..options.headers = {"Content-Type": "application/json"}
      ..interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            var token = await _prefs.token;

            // check is token null or not
            if (token != null) {
              // put authorization on header before sending to API
              options.headers
                  .putIfAbsent(DiConstant.authorization, () => token);
            } else {
              // put x-api-key on header before sending to API
              options.headers
                  .putIfAbsent(DiConstant.apiKey, () => ApiConstant.apiKey);
            }

            // next to request
            return handler.next(options);
          },
        ),
      );

    return dio;
  }
}
