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
      final response = await _repository.placeOrder(request);

      if (response.status == "success" ||
          response.status == true ||
          response.status == "true") {
        order.value = response.order;
        Get.offAllNamed(AppRoutes.orderConfirmer, arguments: response.order);
      } else {
        SnackbarUtil.showError(
          "Order Failed",
          response.message ?? "Something went wrong while placing order.",
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
