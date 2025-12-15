import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../constants/app_keys.dart';
import '../models/guest_address_model.dart';

class GuestAddressController extends GetxController {
  late Box<GuestAddressModel> _box;

  Rx<GuestAddressModel?> selectedAddress = Rx<GuestAddressModel?>(null);

  @override
  void onInit() {
    _box = Hive.box<GuestAddressModel>(AppKeys.guestAddress);

    if (_box.isNotEmpty) {
      selectedAddress.value = _box.getAt(0);
    }

    super.onInit();
  }

  void saveAddress(GuestAddressModel model) {
    if (_box.isNotEmpty) {
      _box.putAt(0, model);
    } else {
      _box.add(model);
    }

    selectedAddress.value = model;
  }

  void clearAddress() {
    _box.clear();
    selectedAddress.value = null;
  }
}