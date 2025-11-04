import 'package:get/get.dart';
import 'package:collection/collection.dart'; // <-- for firstWhereOrNull

import '../models/responses/get_addresses_response.dart';
import '../repositories/get_addresses_repository.dart';

class GetAddressController extends GetxController {

  final GetAddressesRepository _repository = GetAddressesRepository();

  var isLoading = false.obs;
  var addresses = <AddressModel>[].obs;
  var errorMessage = ''.obs;

  var selectedAddressId = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;

      final response = await _repository.getAddressList();

      if (response.status) {
        addresses.assignAll(response.addresses);

        final selected = response.addresses.firstWhereOrNull((a) => a.isSelected)
            ?? response.addresses.firstOrNull;

        selectedAddressId.value = selected?.id;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = "Failed to load addresses. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(int id) {
    selectedAddressId.value = id;
  }

  AddressModel? get selectedAddress =>
      addresses.firstWhereOrNull((a) => a.id == selectedAddressId.value);
}
