import 'package:dry_fish/repositories/products_repository.dart';
import 'package:get/get.dart';
import '../models/responses/products_response.dart';
import '../utils/snackbar_util.dart';

class ProductsController extends GetxController {
  final ProductsRepository _repository = ProductsRepository();

  var isLoading = false.obs;
  var productList = <Product>[].obs;

  Future<void> getProducts() async {
    try {
      isLoading.value = true;

      final response = await _repository.product();

      if (response.success == true) {
        if (response.products != null && response.products!.isNotEmpty) {
          productList.value = response.products!;
        } else {
          productList.clear();
          // SnackbarUtil.showError("Info", "No products found for this category.");
        }
      } else {
        SnackbarUtil.showError(
          "Error",
          "Failed to fetch products. Please try again.",
        );
      }
    } catch (e) {
      SnackbarUtil.showError(
        "Error",
        "Something went wrong while fetching products.",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
