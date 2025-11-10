import 'package:get/get.dart';
import '../models/responses/cancel_order_response.dart';
import '../repositories/cancel_order_respository.dart';
import '../roots/routes.dart';
import '../utils/toast_util.dart'; // 👈 for showing toast

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

        ToastUtil.showSuccess(response.message);

        Get.offAllNamed(AppRoutes.dashBoard);
      } else {
        ToastUtil.showError(response.message);
      }
    } catch (e) {
      message.value = e.toString();
      ToastUtil.showError(message.value);
    } finally {
      isLoading.value = false;
    }
  }
}
