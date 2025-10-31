import 'package:dry_fish/roots/routes.dart';
import 'package:get/get.dart';
import '../models/requests/place_order_request.dart';
import '../models/responses/placeorder_response.dart';
import '../repositories/placeorder_repository.dart';
import '../utils/snackbar_util.dart';

class PlaceOrderController extends GetxController {
  final PlaceorderRepository _repository = PlaceorderRepository();
  final isLoading = false.obs;
  final order = Rxn<Order>();

  Future<void> placeOrderCont(PlaceOrderRequest request) async {
    isLoading.value = true;
    try {
      // ✅ FIXED: pass request in API call
      final response = await _repository.placeOrder(request);

      if (response.status == "success") {
        order.value = response.order;

        SnackbarUtil.showSuccess(
          "Order Placed",
  response.message ?? "",
        );

        Get.offAllNamed(AppRoutes.orderConfirmer);
      } else {
        SnackbarUtil.showError(
          "Order Failed",
  response.message ?? "",
        );
      }
    } catch (e) {
      SnackbarUtil.showError(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
