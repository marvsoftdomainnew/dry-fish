import 'package:get/get.dart';
import 'package:chavan_brothers/models/responses/product_details_response.dart';
import 'package:chavan_brothers/repositories/product_details_repository.dart';

class ProductDetailsController extends GetxController {
  final ProductDetailsRepository _repository = ProductDetailsRepository();

  var isLoading = false.obs;
  var productDetails = Rx<ProductDetails?>(null);
  var errorMessage = ''.obs;

  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.showproductdetails(Id: id);

      if (response.success == true && response.product != null) {
        productDetails.value = response.product;
      } else {
        errorMessage.value = 'Product not found';
        productDetails.value = null;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load product details: $e';
      productDetails.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
