import 'package:dio/dio.dart';
import 'package:spos/data/network/apis/constants/endpoint.dart';
import 'package:spos/data/network/dio_client.dart';
import 'package:spos/models/auth/login_model.dart';

class ApiLogin {
  // dio instances
  final DioClient _dioClient;

  // constructor
  ApiLogin(this._dioClient);

  Future<LoginModel> login(String email, String password) async {
    final data = {
      "email": email,
      "password": password,
    };

    try {
      final Response response =
          await _dioClient.post(Endpoint.login, data: data);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
