import 'package:chavan_brothers/models/responses/shop_list_response.dart';

import '../constants/api_constants.dart';
import '../services/api_service.dart';

class ShopListRepo {
  final _dio = ApiService.dio;

  Future<ShopListResponse> fetchshops() async {
    final response = await _dio.get(ApiConstants.shopListUrl);
    return ShopListResponse.fromJson(response.data);
  }
}