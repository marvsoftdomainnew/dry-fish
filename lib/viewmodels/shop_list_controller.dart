import 'package:get/get.dart';
import '../models/responses/shop_list_response.dart';
import '../repositories/shop_list_repo.dart';

class ShopListController extends GetxController {
  final ShopListRepo _repo = ShopListRepo();

  /// Observables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final shops = <Shop>[].obs;

  /// Selected shop
  final selectedShop = Rx<Shop?>(null);

  /// Fetch shops from API
  Future<void> fetchShops() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repo.fetchshops();

      if (response.success) {
        shops.assignAll(response.shops);
        if (shops.isNotEmpty) {
          selectedShop.value = shops.first;
        }
      } else {
        shops.clear();
        errorMessage.value = 'Failed to load shops';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print("❌ Error fetching shops: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a shop
  void selectShop(Shop shop) {
    selectedShop.value = shop;
  }

  /// Clear shop list
  void clearShops() {
    shops.clear();
    selectedShop.value = null;
  }
}
