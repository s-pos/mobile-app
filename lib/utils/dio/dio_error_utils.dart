import 'package:dio/dio.dart';
import 'package:spos/constants/api_constant.dart';

class DioErrorUtil {
  static Map<String, dynamic> handleError(DioError error) {
    String errMessage = ApiConstant.errGlobal;
    int statusCode = 500;

    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errMessage = ApiConstant.errCancel;
          break;
        case DioErrorType.connectTimeout:
          errMessage = ApiConstant.errConnectionTimeout;
          statusCode = 504;
          break;
        case DioErrorType.receiveTimeout:
          errMessage = ApiConstant.errReceivedTimeout;
          statusCode = 504;
          break;
        case DioErrorType.sendTimeout:
          errMessage = ApiConstant.errSendTimeout;
          statusCode = 504;
          break;
        case DioErrorType.response:
          errMessage = error.response?.data?["status"]["reason"];
          statusCode = error.response?.statusCode ?? 500;
          break;
        default:
          errMessage = ApiConstant.errGlobal;
          statusCode = 500;
          break;
      }
    }

    return {
      "reason": errMessage,
      "statusCode": statusCode,
    };
  }
}
