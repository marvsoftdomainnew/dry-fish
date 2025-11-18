
import 'package:get/get.dart';
import '../../utils/snackbar_util.dart';
import '../repositories/increase_quantity_repository.dart';
class IncreaseQuantityController extends GetxController {
  final _repo = IncreaseQuantityRepository();

  final isLoading = false.obs;
  final message = ''.obs;
  final isSuccess = false.obs;

  Future<void> increaseQuantity(String id) async {
    try {
      isLoading.value = true;
      message.value = '';
      isSuccess.value = false;

      final response = await _repo.increaseqantity(Id: id);

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
