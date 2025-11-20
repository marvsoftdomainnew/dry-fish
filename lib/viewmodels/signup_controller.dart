// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../models/requests/signup_request.dart';
// import '../models/responses/signup_response.dart';
// import '../repositories/signup_repository.dart';
// import '../services/network_exceptions.dart';
// import '../utils/snackbar_util.dart';


// class SignupController extends GetxController {
//   final SignupRepository _repository = SignupRepository();
//   final isLoading = false.obs;

//   Future<void> signup(SignupRequest request) async {
//     isLoading.value = true;

//     try {
//       final SignupResponse response = await _repository.signup(request);
//       if (response.status == true) {
//         Navigator.pop(Get.context!);
//         SnackbarUtil.showSuccess("Success", response.message ?? "Signup successful");
//       } else {
//         SnackbarUtil.showError("Error", response.message ?? "Signup failed");
//       }
//     } catch (e) {
//       SnackbarUtil.showError("Error", "Unexpected error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }



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
      if (response.status == true) {
        Navigator.pop(Get.context!);
        SnackbarUtil.showSuccess("Success", response.message ?? "Signup successful");
      } else {
        // Handle API-specific logical errors (e.g., status: false with a message)
        SnackbarUtil.showError("Error", response.message ?? "Signup failed");
      }
    } catch (e) {
      // Specific handling for DioException (which covers HTTP status codes like 422)
      if (e is DioException) {
        // Check if the status code is 422
        if (e.response?.statusCode == 422) {
          try {
            // Attempt to parse the response body as a SignupResponse
            SignupResponse errorResponse = SignupResponse.fromJson(e.response?.data);
            
            // Prioritize the main message
            if (errorResponse.message != null && errorResponse.message!.isNotEmpty) {
              SnackbarUtil.showError("Error", errorResponse.message!);
            } else if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
              // If no main message, display the first specific validation error
              String firstError = errorResponse.errors!.values.first.first;
              SnackbarUtil.showError("Validation Error", firstError);
            } else {
              SnackbarUtil.showError("Error", "Validation failed (422) with no specific message.");
            }
          } catch (jsonError) {
            // Fallback if the 422 response body isn't in the expected format
            SnackbarUtil.showError("Error", "Failed to parse validation errors: $jsonError");
          }
        } else {
          // Handle other Dio error codes (401, 500, etc.)
          SnackbarUtil.showError("Network Error", e.message ?? "An network error occurred.");
        }
      } else {
        // Handle non-Dio exceptions
        SnackbarUtil.showError("Error", "Unexpected error: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}