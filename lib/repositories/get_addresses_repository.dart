import '../constants/api_constants.dart';
import '../models/responses/get_addresses_response.dart';
import '../services/api_service.dart';

class GetAddressesRepository {
  final _dio = ApiService.dio;

  Future<GetAddressesResponse> getAddressList() async {
    final response = await _dio.get(
      ApiConstants.getAddressesUrl,
    );
    return GetAddressesResponse.fromJson(response.data);
  }
}