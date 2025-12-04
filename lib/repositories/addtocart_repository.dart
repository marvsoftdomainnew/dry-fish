import 'package:chavan_brothers/models/requests/add_to_cart_request.dart';
import 'package:chavan_brothers/models/responses/add_to_cart_response.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';

class AddtocartRepository {
  final _dio = ApiService.dio;

  Future<AddToCartResponse> addtocart(AddToCartRequest request) async {
    final response = await _dio.post(
      ApiConstants.addtocarturl,
      data: request.toJson(),
    );
    return AddToCartResponse.fromJson(response.data);
  }
}
