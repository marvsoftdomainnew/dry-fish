// import 'package:chavan_brothers/models/responses/products_by_category_response.dart';
import 'package:chavan_brothers/models/responses/products_response.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';

class ProductsRepository {
  final _dio = ApiService.dio;

  Future<ProductsResponse> product() async {
    final response = await _dio.get(ApiConstants.productsUrl());
    return ProductsResponse.fromJson(response.data);
  }
}
