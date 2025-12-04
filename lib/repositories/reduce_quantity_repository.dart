import 'package:chavan_brothers/services/api_service.dart';

import '../constants/api_constants.dart';
import '../models/responses/reduce_quantity_response.dart';

class ReduceQuantityRepository {
  final _dio = ApiService.dio;

  Future<ReduceQuantityResponse> reduceqantity({required String Id}) async {
    final url = "${ApiConstants.reducequantityurl}/$Id";

    final response = await _dio.post(url);
    return ReduceQuantityResponse.fromJson(response.data);
  }
}
