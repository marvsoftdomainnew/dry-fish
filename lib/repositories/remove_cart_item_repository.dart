import 'package:chavan_brothers/services/api_service.dart';

import '../constants/api_constants.dart';
import '../models/responses/remove_cart_item_response.dart';

class RemoveCartItemRepo {
  final _dio = ApiService.dio;

  Future<RemoveCartItemResponse> removeFromCart({required String Id}) async {
    final url = "${ApiConstants.removefromcarturl}/$Id";

    final response = await _dio.get(url);
    return RemoveCartItemResponse.fromJson(response.data);
  }
}
