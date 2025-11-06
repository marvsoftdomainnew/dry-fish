import 'package:get/get.dart';
import '../models/responses/cart_response.dart';
import '../repositories/cart_repository.dart';

class CartItemController extends GetxController {
  final _repo = CartItemRepo();

  /// Observables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final cartItems = <CartItem>[].obs;

  /// Totals
  RxInt totalItems = 0.obs;
  RxDouble totalPrice = 0.0.obs;

  final Map<int, RxBool> itemLoading = {};

  void initItemLoaders() {
    for (var item in cartItems) {
      itemLoading[item.id] ??= false.obs;
        }
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repo.fetchcartItems();

      if (response.success == true) {
        cartItems.assignAll(response.cart);
      } else {
        cartItems.clear();
      }

      updateTotals();
      initItemLoaders();
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print("❌ Error fetching cart: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateTotals() {
    totalItems.value = cartItems.fold<int>(
      0,
          (sum, item) => sum + (item.quantity),
    );

    totalPrice.value = cartItems.fold<double>(
      0.0,
          (sum, item) => sum + (item.total),
    );
  }
}
