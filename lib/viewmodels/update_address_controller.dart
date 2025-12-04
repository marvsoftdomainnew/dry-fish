import 'package:chavan_brothers/utils/snackbar_util.dart';
import 'package:get/get.dart';
import '../models/requests/update_address_request.dart';
import '../models/responses/update_address_response.dart';
import '../repositories/update_address_repo.dart';

class UpdateAddressController extends GetxController {
  final UpdateAddressRepo _repo = UpdateAddressRepo();

  var isLoading = false.obs;
  UpdateAddressResponse? updateResponse;

  Future<bool> updateAddress(String id, UpdateAddressRequest request) async {
    try {
      isLoading.value = true;

      updateResponse = await _repo.updateAddress(id: id, request: request);

      if (updateResponse != null && updateResponse!.status) {
        SnackbarUtil.showSuccess("Success", updateResponse!.message);
        return true;
      } else {
        SnackbarUtil.showError(
          "Failed",
          updateResponse?.message ?? "Update failed",
        );
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong while updating address");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
