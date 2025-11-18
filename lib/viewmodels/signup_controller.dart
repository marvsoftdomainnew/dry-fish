import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/requests/signup_request.dart';
import '../models/responses/signup_response.dart';
import '../repositories/signup_repository.dart';
import '../services/network_exceptions.dart';
import '../utils/snackbar_util.dart';


class SignupController extends GetxController {
  final SignupRepository _repository = SignupRepository();
  final isLoading = false.obs;

  Future<void> signup(SignupRequest request) async {
    isLoading.value = true;

    try {
      final SignupResponse response = await _repository.signup(request);
      if (response.status == "success") {
        Navigator.pop(Get.context!);
        SnackbarUtil.showSuccess("Success", response.message ?? "Signup successful");
      } else {
        SnackbarUtil.showError("Error", response.message ?? "Signup failed");
      }
    } on DioException catch (e) {
      final message = NetworkExceptions.getErrorMessage(e);
      SnackbarUtil.showError("Network Error", message);
    } catch (e) {
      SnackbarUtil.showError("Error", "Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
