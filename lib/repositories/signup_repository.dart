import 'package:chavan_brothers/models/requests/signup_request.dart';
import 'package:chavan_brothers/models/responses/signup_response.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';

class SignupRepository {
  final _dio = ApiService.dio;

  Future<SignupResponse> signup(SignupRequest request) async {
    final response = await _dio.post(
      ApiConstants.signupUrl,
      data: request.toJson(),
    );
    return SignupResponse.fromJson(response.data);
  }
}
