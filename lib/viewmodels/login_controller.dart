
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_keys.dart';
import '../models/requests/login_request.dart';
import '../models/responses/login_response.dart';
import '../repositories/login_repository.dart';
import '../roots/routes.dart';
import '../services/sharedpreferences_service.dart';
import '../utils/snackbar_util.dart';

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
Future<void> login() async {
  final phone = phoneController.text.trim();
  final password = passwordController.text.trim();

  if (!isFormValid) {
    SnackbarUtil.showError("Invalid Input", "Please enter valid phone and password.");
    return;
  }

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
      Get.offAllNamed(AppRoutes.dashBoard);

    } else {
      final msg = response.message ?? "Login failed";
      errorText.value = msg;
      SnackbarUtil.showError("Error", msg);
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

  } finally {
    isLoading.value = false;
  }
}
Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppKeys.token);
    await prefs.remove(AppKeys.isLogin);
    await prefs.remove(AppKeys.user);
    print("👋 User logged out and data cleared");
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }
}
