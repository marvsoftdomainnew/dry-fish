import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/app_colors.dart';
import '../../models/requests/signup_request.dart';
import '../../roots/routes.dart';
import '../../viewmodels/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final signupController = Get.put(SignupController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Validation error messages
  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateForm() {
    setState(() {
      // Validate Name
      if (nameController.text.trim().isEmpty) {
        nameError = "Name is required";
      } else {
        nameError = null;
      }

      // Validate Email
      if (emailController.text.trim().isEmpty) {
        emailError = "Email is required";
      } else if (!emailController.text.trim().isEmail) {
        emailError = "Enter a valid email";
      } else {
        emailError = null;
      }

      // Validate Phone
      if (phoneController.text.trim().isEmpty) {
        phoneError = "Phone number is required";
      } else if (phoneController.text.trim().length != 10) {
        phoneError = "Phone number must be 10 digits";
      } else {
        phoneError = null;
      }

      // Validate Password
      if (passwordController.text.trim().isEmpty) {
        passwordError = "Password is required";
      } else if (passwordController.text.trim().length < 6) {
        passwordError = "Password must be at least 6 characters";
      } else {
        passwordError = null;
      }

      // Validate Confirm Password
      if (confirmPasswordController.text.trim().isEmpty) {
        confirmPasswordError = "Please confirm your password";
      } else if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = null;
      }
    });
  }

  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isEmail &&
        phoneController.text.trim().length == 10 &&
        passwordController.text.trim().length >= 6 &&
        passwordController.text.trim() == confirmPasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Registration",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        iconTheme: IconThemeData(
            size: 7.w,
            color: AppColors.white
        ),
      ),
      body: Stack(
        children: [
          /// Background Watermark Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/bgImages/loginBg.jpeg',
                  fit: BoxFit.cover,   // cover is important
                ),
              ),
            ),
          ),


          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.04),

                    // Logo
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/applogo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.045),

                    Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // NAME FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _styledField(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          child: TextField(
                            controller: nameController,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (_) => validateForm(),
                            decoration: _fieldDecoration(
                              screenWidth: screenWidth,
                              hint: "Full Name",
                              icon: Icons.person_outline,
                            ),
                          ),
                        ),
                        if (nameError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 12),
                            child: Text(
                              nameError!,
                              style: TextStyle(
                                color: AppColors.alertRed,
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 15),

                    // EMAIL FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _styledField(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          child: TextField(
                            controller: emailController,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (_) => validateForm(),
                            decoration: _fieldDecoration(
                              screenWidth: screenWidth,
                              hint: "Email Address",
                              icon: Icons.email_outlined,
                            ),
                          ),
                        ),
                        if (emailError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 12),
                            child: Text(
                              emailError!,
                              style: TextStyle(
                                color: AppColors.alertRed,
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 15),

                    // PHONE FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _styledField(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          child: TextField(
                            controller: phoneController,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (_) => validateForm(),
                            decoration: _fieldDecoration(
                              screenWidth: screenWidth,
                              hint: "Phone Number",
                              icon: Icons.phone_android_outlined,
                              showCounter: false,
                            ),
                          ),
                        ),
                        if (phoneError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 12),
                            child: Text(
                              phoneError!,
                              style: TextStyle(
                                color: AppColors.alertRed,
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 15),

                    // PASSWORD FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => _styledField(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          child: TextField(
                            controller: passwordController,
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: !isPasswordVisible.value,
                            onChanged: (_) => validateForm(),
                            decoration: _fieldDecoration(
                              screenWidth: screenWidth,
                              hint: "Password",
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(
                                  isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.hintTextGrey,
                                ),
                                onPressed: () =>
                                isPasswordVisible.value = !isPasswordVisible.value,
                              ),
                            ),
                          ),
                        )),
                        if (passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 12),
                            child: Text(
                              passwordError!,
                              style: TextStyle(
                                color: AppColors.alertRed,
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 15),

                    // CONFIRM PASSWORD FIELD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => _styledField(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          child: TextField(
                            controller: confirmPasswordController,
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: !isConfirmPasswordVisible.value,
                            onChanged: (_) => validateForm(),
                            decoration: _fieldDecoration(
                              screenWidth: screenWidth,
                              hint: "Confirm Password",
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.hintTextGrey,
                                ),
                                onPressed: () =>
                                isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value,
                              ),
                            ),
                          ),
                        )),
                        if (confirmPasswordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 12),
                            child: Text(
                              confirmPasswordError!,
                              style: TextStyle(
                                color: AppColors.alertRed,
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // SIGNUP BUTTON (Always Enabled)
                    Obx(() => Container(
                      width: double.infinity,
                      height: screenHeight * 0.065,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.5),
                            blurRadius: 3,
                            spreadRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ElevatedButton(
                          onPressed: signupController.isLoading.value
                              ? null
                              : () {
                            validateForm();
                            if (isFormValid) {
                              final req = SignupRequest(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                password: passwordController.text.trim(),
                                passwordConfirmation: confirmPasswordController.text.trim(),
                              );
                              signupController.signup(req);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          child: signupController.isLoading.value
                              ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// INPUT DECORATION
  InputDecoration _fieldDecoration({
    required double screenWidth,
    required String hint,
    required IconData icon,
    Widget? suffix,
    bool showCounter = true,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffix,
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.hintTextGrey,
        fontSize: screenWidth * 0.043,
        fontWeight: FontWeight.w500,
      ),
      counterText: showCounter ? null : "",
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical: 0),
    );
  }

  /// STYLED FIELD CONTAINER
  Widget _styledField({
    required double screenHeight,
    required double screenWidth,
    required Widget child,
  }) {
    return Container(
      height: screenHeight * 0.065,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 0.5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}



