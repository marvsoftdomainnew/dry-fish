// import 'package:dry_fish/models/responses/products_by_category_response.dart';
import '../constants/api_constants.dart';
import '../models/responses/order_history_response.dart';
import '../services/api_service.dart';

class OrderListRespository {
  final _dio = ApiService.dio;

  Future<OrderHistoryResponse> getorderlist() async {
    final response = await _dio.get(
      ApiConstants.orderListUrl,
    );
    return OrderHistoryResponse.fromJson(response.data);
  }
}