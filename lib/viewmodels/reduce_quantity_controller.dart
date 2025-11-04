// import 'package:get/get.dart';
// import '../../repositories/reduce_quantity_repository.dart';

// class ReduceQuantityController extends GetxController {
//   final _repo = ReduceQuantityRepository();

//   /// Observables
//   final isLoading = false.obs;
//   final message = ''.obs;
//   final isSuccess = false.obs;

//   /// Method to call API
//   Future<void> reduceQuantity(String id) async {
//     try {
//       isLoading.value = true;
//       message.value = '';
//       isSuccess.value = false;

//       final response = await _repo.reduceqantity(Id: id);

//       if (response.status) {
//         isSuccess.value = true;
//         message.value = response.message; // e.g. "Quantity reduced successfully"
//       } else {
//         message.value = response.message; // e.g. "Failed to reduce quantity"
//       }
//     } catch (e) {
//       message.value = 'Error: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import '../../utils/snackbar_util.dart';
import '../../repositories/reduce_quantity_repository.dart';

class ReduceQuantityController extends GetxController {
  final _repo = ReduceQuantityRepository();

  final isLoading = false.obs;
  final message = ''.obs;
  final isSuccess = false.obs;

  Future<void> reduceQuantity(String id) async {
    try {
      isLoading.value = true;
      message.value = '';
      isSuccess.value = false;

      final response = await _repo.reduceqantity(Id: id);

      if (response.status) {
        isSuccess.value = true;
        message.value = response.message;
      } else {
        message.value = response.message;
      }
    } catch (e) {
      message.value = "Error: ${e.toString()}";

      SnackbarUtil.showError("Error", message.value);
    } finally {
      isLoading.value = false;
    }
  }
}
