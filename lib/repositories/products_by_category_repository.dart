import 'package:chavan_brothers/models/responses/products_by_category_response.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';

class ProductsByCategoryRepository {
  final _dio = ApiService.dio;

  Future<ProductsByCategoryResponse> productByCategory(int categoryId) async {
    final response = await _dio.get(
      ApiConstants.productByCategoryUrl(categoryId),
    );
    return ProductsByCategoryResponse.fromJson(response.data);
  }
}
