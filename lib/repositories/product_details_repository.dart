import 'package:chavan_brothers/models/responses/product_details_response.dart';
import 'package:chavan_brothers/services/api_service.dart';

import '../constants/api_constants.dart';

class ProductDetailsRepository {
  final _dio = ApiService.dio;

  Future<ProductDetailsResponse> showproductdetails({
    required String Id,
  }) async {
    final url = "${ApiConstants.showproductdetailsUrl}/$Id";

    final response = await _dio.get(url);
    return ProductDetailsResponse.fromJson(response.data);
  }
}
