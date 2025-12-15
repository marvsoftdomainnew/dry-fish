
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_keys.dart';
import '../models/guest_address_model.dart';
import '../models/requests/add_new_address_request.dart';
import '../models/requests/login_request.dart';
import '../models/responses/login_response.dart';
import '../repositories/login_repository.dart';
import '../roots/routes.dart';
import '../services/sharedpreferences_service.dart';
import '../utils/snackbar_util.dart';
import 'add_new_addresss_controller.dart';

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  class LoginController extends GetxController {
  final LoginRepository _repository = LoginRepository();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isValidNumber = false.obs;
  var isPasswordValid = false.obs;
  var isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorText = RxnString();

  void onPhoneChanged(String value, BuildContext context) {
    if (value.length == 10) FocusScope.of(context).unfocus();
    isValidNumber.value = value.length == 10;
  }

  void onPasswordChanged(String value) {
    isPasswordValid.value = value.isNotEmpty && value.length >= 6;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool get isFormValid => isValidNumber.value && isPasswordValid.value;

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  Future<bool?> login() async {
  final phone = phoneController.text.trim();
  final password = passwordController.text.trim();

  if (!isFormValid) {
    SnackbarUtil.showError("Invalid Input", "Please enter valid phone and password.");
    return false;
  }
  String loginSource = "";
  isLoading.value = true;
  errorText.value = null;

  try {
    final request = LoginRequest(phone: phone, password: password);
    final LoginResponse response = await _repository.login(request);

    if (response.status == true) {
      final token = response.accessToken ?? '';
      final user = response.user;

      final prefs = await SharedPreferencesService.getInstance();
      await prefs.setString(AppKeys.token, token);
      await prefs.setBool(AppKeys.isLogin, true);

      if (user != null) {
        final userJson = jsonEncode(user.toJson());
        await prefs.setString(AppKeys.user, userJson);
      }

      SnackbarUtil.showSuccess("Success", response.message ?? "Login successful");
      await _syncGuestAddressIfExists();
      // Determine navigation source
      final args = Get.arguments ?? {};
      loginController.loginSource = args["from"] ?? "";

      if (loginSource == "cart" || loginSource == "address" || loginSource == "checkout") {
        Get.back(result: true);
        loginSource = ""; // reset after use
        return true;
      }

      // Normal login → Go Dashboard
      Get.offAllNamed(AppRoutes.dashBoard);
      return true;

    } else {
      final msg = response.message ?? "Login failed";
      errorText.value = msg;
      SnackbarUtil.showError("Error", msg);
      return false;
    }

  } on DioException catch (e) {
    String message = "Something went wrong";

    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;

      if (data is Map && data.containsKey("message")) {
        message = data["message"];  // 👈 Show real API message
      }
    } else {
      message = e.message ?? "Network error";
    }

    errorText.value = message;
    SnackbarUtil.showError("Error", message);

  } catch (e) {
    final msg = "Unexpected error: $e";
    errorText.value = msg;
    SnackbarUtil.showError("Error", msg);
    return false;
  } finally {
    isLoading.value = false;
  }
}

  Future<void> _syncGuestAddressIfExists() async {
    final box = Hive.box<GuestAddressModel>(AppKeys.guestAddress);

    if (box.isEmpty) {
      print("🔍 No guest address found in Hive → Skipping sync");
      return;
    }

    final guest = box.getAt(0);
    if (guest == null) return;
    //
    // print("🔥 FOUND GUEST ADDRESS → Preparing to sync");
    // print("Guest Name: ${guest.name}");
    // print("Phone: ${guest.phone}");
    // print("Flat: ${guest.flat}");
    // print("Street: ${guest.street}");
    // print("Locality: ${guest.locality}");
    // print("Pincode: ${guest.pincode}");

    await _syncGuestAddressToServer(guest);
  }

  Future<void> _syncGuestAddressToServer(GuestAddressModel guest) async {
    final AddNewAddressController addressController = Get.put(AddNewAddressController());

    final request = AddNewAddressRequest(
      name: guest.name,
      phone: "+91-${guest.phone}",
      flat: guest.flat,
      street: guest.street,
      building: guest.building,
      country: "India",
      city: guest.locality,
      state: guest.block.isEmpty ? "N/A" : guest.block,
      zip: guest.pincode,
      landmark: guest.landmark,
      locality: guest.locality,
      addressType: guest.addressType.toLowerCase(),
      isSelected: true,
    );

    // print("📤 SENDING GUEST ADDRESS TO SERVER...");
    // print("Payload → ${jsonEncode(request)}");

    await addressController.addNewAddress(request);

    if (addressController.addNewAddressResponse?.status == true) {
      // print("✅ Guest address synced to server successfully!");

      // remove from Hive
      final box = Hive.box<GuestAddressModel>(AppKeys.guestAddress);
      await box.clear();
      // print("🗑 Guest address cleared from Hive after sync");
    } else {
      print("❌ Failed to sync guest address");
    }
  }


  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppKeys.token);
    await prefs.remove(AppKeys.isLogin);
    await prefs.remove(AppKeys.user);
    print("👋 User logged out and data cleared");
    Get.offAllNamed(AppRoutes.login);
  }
}
