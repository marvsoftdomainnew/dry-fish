import 'package:get/get.dart';
import '../models/responses/order_details_response.dart';
import '../repositories/order_details_repository.dart';

class OrderDetailController extends GetxController {

  final OrderDetailRespository _repo = OrderDetailRespository();

  // Observables
  var isLoading = false.obs;
  var orderDetails = Rxn<OrderDetailsResponse>(); 
  var errorMessage = ''.obs;

  // Fetch Order Details
  Future<void> fetchOrderDetails(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repo.orderDetail(Id: orderId); 
      orderDetails.value = result;

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}