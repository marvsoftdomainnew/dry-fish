import 'package:get/get.dart';
import '../constants/app_keys.dart';
import '../models/responses/order_history_response.dart';
import '../repositories/order_list_respository.dart';
import '../services/sharedpreferences_service.dart';

class OrderHistoryController extends GetxController {
  final OrderListRespository repository = OrderListRespository();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final prefs = await SharedPreferencesService.getInstance();
      final isLogged = prefs.getBool(AppKeys.isLogin) ?? false;

      if (!isLogged) {
        errorMessage.value = "Please login to view your orders";
        return;
      }

      final response = await repository.getorderlist();

      /// ✅ Check API Status
      if (response.status.toLowerCase() == "success") {
        if (response.orders.isNotEmpty) {
          orders.assignAll(response.orders);
        } else {
          errorMessage.value = "No orders found";
        }
      } else {
        errorMessage.value = "Failed to load orders";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong, please try again";
    } finally {
      isLoading.value = false;
    }
  }
}
