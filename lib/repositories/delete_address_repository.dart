import 'package:chavan_brothers/services/api_service.dart';
import '../constants/api_constants.dart';
import '../models/responses/delete_address_response.dart';

class DeleteAddressRepository {
  final _dio = ApiService.dio;

  Future<DeleteAddressResponse> removeaddress({required String Id}) async {
    final url = "${ApiConstants.deleteaddressurl}/$Id";

    final response = await _dio.get(url);
    return DeleteAddressResponse.fromJson(response.data);
  }
}
