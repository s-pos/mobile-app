import 'package:spos/data/network/apis/constants/endpoint.dart';
import 'package:spos/data/network/dio_client.dart';
import 'package:spos/models/auth/register_model.dart';

class ApiRegister {
  final DioClient _dioClient;

  ApiRegister(this._dioClient);

  Future<RegisterModel> register(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post(Endpoint.register, data: data);

      return RegisterModel.fromString(response);
    } catch (e) {
      rethrow;
    }
  }
}
