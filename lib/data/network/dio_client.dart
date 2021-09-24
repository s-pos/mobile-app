import 'package:dio/dio.dart';

class DioClient {
  // dio instance
  final Dio _dio;

  // constructor
  DioClient(this._dio);

  // REST API Get
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryString,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceivedProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        endpoint,
        queryParameters: queryString,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceivedProgress,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // REST API Post
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryString,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceivedProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryString,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceivedProgress,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
