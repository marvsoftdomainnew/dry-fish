import 'package:get/get.dart';
import '../../models/requests/add_to_cart_request.dart';
import '../../models/responses/add_to_cart_response.dart';
import '../../repositories/addtocart_repository.dart';
import '../../utils/snackbar_util.dart';

class AddToCartController extends GetxController {
  final AddtocartRepository repository;

  AddToCartController({required this.repository});

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final response = Rxn<AddToCartResponse>();

  Future<void> addToCart(AddToCartRequest request) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.addtocart(request);
      response.value = result;

      if (result.status) {
      } else {
      }
    } catch (e) {
      errorMessage.value = e.toString();
      SnackbarUtil.showError('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
