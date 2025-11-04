import 'package:get/get.dart';

import '../models/responses/cancel_order_response.dart';
import '../repositories/cancel_order_respository.dart';

class CancelOrderController extends GetxController {
  final CancelOrderRespository _repo = CancelOrderRespository();

  RxBool isLoading = false.obs;
  RxBool isCancelled = false.obs;
  RxString message = "".obs;

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;

      CancelOrderResponse response = await _repo.cancelOrder(Id: orderId);

      message.value = response.message;

      if (response.status) {
        isCancelled.value = true;
      }

    } catch (e) {
      message.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}