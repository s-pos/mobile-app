import 'package:spos/data/network/apis/constants/endpoint.dart';
import 'package:spos/data/network/dio_client.dart';
import 'package:spos/models/auth/verification_model.dart';

class ApiVerification {
  final DioClient _dioClient;

  ApiVerification(this._dioClient);

  Future<VerificationModel> verificationRegister(
      Map<String, dynamic> data) async {
    try {
      final res =
          await _dioClient.post(Endpoint.verificationRegister, data: data);

      return VerificationModel.fromString(res);
    } catch (e) {
      rethrow;
    }
  }
}
