import 'package:chavan_brothers/models/responses/placeorder_response.dart';
import '../constants/api_constants.dart';
import '../models/requests/place_order_request.dart';
import '../services/api_service.dart';

class PlaceorderRepository {
  final _dio = ApiService.dio;

  Future<PlaceorderResponse> placeOrder(PlaceOrderRequest request) async {
    final response = await _dio.post(
      ApiConstants.placeorderurl,
      data: request.toJson(),
    );
    return PlaceorderResponse.fromJson(response.data);
  }
}
