import 'package:chavan_brothers/models/responses/category_response.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';

class CategoryRepository {
  final _dio = ApiService.dio;

  Future<CategoryResponse> category() async {
    final response = await _dio.get(ApiConstants.getCategoryUrl);
    return CategoryResponse.fromJson(response.data);
  }
}
