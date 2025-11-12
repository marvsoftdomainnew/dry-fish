// import 'package:get/get.dart';

// import '../repositories/remove_cart_item_repository.dart';

// class RemoveCartItemController extends GetxController {
//   final _repo = RemoveCartItemRepo();

//   /// Observables
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//   final successMessage = ''.obs;

//   /// 🔹 Remove item from cart API call
//   Future<void> removeCartItem(String id) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       successMessage.value = '';

//       final response = await _repo.removeFromCart(Id: id);

//       if (response.status) {
//         successMessage.value = response.message;
//       } else {
//         errorMessage.value = response.message.isNotEmpty
//             ? response.message
//             : 'Failed to remove item';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }



import 'package:get/get.dart';
import '../../utils/snackbar_util.dart';  
import '../repositories/remove_cart_item_repository.dart';

class RemoveCartItemController extends GetxController {
  final _repo = RemoveCartItemRepo();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  Future<void> removeCartItem(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _repo.removeFromCart(Id: id);

      if (response.status) {
        successMessage.value = response.message;
        SnackbarUtil.showSuccess("Removed", successMessage.value);   // ✅ Snackbar here
      } else {
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : "Failed to remove item";
        SnackbarUtil.showError("Error", errorMessage.value);         // ❌ Snackbar here
      }

    } catch (e) {
      errorMessage.value = "Error: ${e.toString()}";
      SnackbarUtil.showError("Error", errorMessage.value);           // ❌ Snackbar here

    } finally {
      isLoading.value = false;
    }
  }
}
