import 'package:chavan_brothers/services/api_service.dart';

import '../constants/api_constants.dart';
import '../models/responses/increase_quantity_response.dart';

class IncreaseQuantityRepository {
  final _dio = ApiService.dio;

  Future<IncreaseQuantityResponse> increaseqantity({required String Id}) async {
    final url = "${ApiConstants.increasequantityurl}/$Id";

    final response = await _dio.post(url);
    return IncreaseQuantityResponse.fromJson(response.data);
  }
}
