import 'package:dry_fish/services/api_service.dart';
import '../constants/api_constants.dart';
import '../models/responses/order_details_response.dart';

class OrderDetailRespository{
  final _dio = ApiService.dio;

  Future<OrderDetailsResponse> orderDetail({required String Id}) async {
    final url = "${ApiConstants.orderDetailUrl}/$Id";

    final response = await _dio.get(url);
    return OrderDetailsResponse.fromJson(response.data);
  }
}