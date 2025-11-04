import 'package:dry_fish/services/api_service.dart';
import '../constants/api_constants.dart';
import '../models/responses/cancel_order_response.dart';

class CancelOrderRespository{
  final _dio = ApiService.dio;

  Future<CancelOrderResponse> cancelOrder({required String Id}) async {
    final url = "${ApiConstants.cancelOrderurl}/$Id";

    final response = await _dio.get(url);
    return CancelOrderResponse.fromJson(response.data);
  }
}
