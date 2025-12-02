// import 'dart:async';
// import 'dart:io';
// import 'package:dry_fish/roots/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import '../../Constants/app_colors.dart';
// import '../../widgets/custom_button.dart';
//
// class OtpVerificationScreen extends StatefulWidget {
//   final String phoneNumber;
//
//   const OtpVerificationScreen({Key? key, required this.phoneNumber})
//       : super(key: key);
//
//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   bool isOtpComplete = false;
//
//   Timer? _timer;
//   int _remainingSeconds = 30;
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _remainingSeconds = 30;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds == 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           _remainingSeconds--;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _otpController.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       // backgroundColor: AppColors.bgColor,
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           /// Background Watermark Image
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.2,
//               child: Image.asset(
//                 'assets/images/bgImages/loginBg.jpeg',
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//
//           /// Foreground Content
//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Back Arrow (instead of AppBar)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: GestureDetector(
//                       onTap: () => Get.back(),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.extraLightestPrimary,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: const EdgeInsets.all(13),
//                         child: Icon(
//                           Platform.isIOS
//                               ? Icons.arrow_back_ios
//                               : Icons.arrow_back_rounded,
//                           color: AppColors.primary,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.05),
//                   // Logo
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.asset(
//                         'assets/images/applogo.png',
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: screenHeight * 0.045),
//
//                   Text(
//                     'Enter the 6-digit code',
//                     style: TextStyle(
//                       fontSize: screenWidth * 0.050,
//                       color: AppColors.black,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//
//                   SizedBox(height: screenHeight * 0.01),
//
//                   Text(
//                     'We sent an OTP to ${widget.phoneNumber}',
//                     style: GoogleFonts.nunito(
//                       fontSize: screenWidth * 0.035,
//                       color: AppColors.darkGrey,
//                     ),
//                   ),
//
//                   SizedBox(height: screenHeight * 0.04),
//
//                   // OTP Input
//                   Center(
//                     child: Pinput(
//                       length: 6,
//                       controller: _otpController,
//                       keyboardType: TextInputType.number,
//                       defaultPinTheme: PinTheme(
//                         width: screenWidth * 0.12,
//                         height: screenWidth * 0.14,
//                         textStyle: GoogleFonts.nunito(
//                           fontSize: screenWidth * 0.060,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.black,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: AppColors.hintTextGrey),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                       ),
//                       focusedPinTheme: PinTheme(
//                         width: screenWidth * 0.12,
//                         height: screenWidth * 0.14,
//                         textStyle: GoogleFonts.nunito(
//                           fontSize: screenWidth * 0.060,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.alertRed,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: AppColors.primary, width: 1),
//                         ),
//                       ),
//                       submittedPinTheme: PinTheme(
//                         width: screenWidth * 0.12,
//                         height: screenWidth * 0.14,
//                         textStyle: GoogleFonts.nunito(
//                           fontSize: screenWidth * 0.060,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.confirmGreen,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: AppColors.confirmGreen),
//                         ),
//                       ),
//                       onChanged: (pin) {
//                         setState(() {
//                           isOtpComplete = pin.length == 6;
//                         });
//                       },
//                       onCompleted: (pin) {
//                         setState(() {
//                           isOtpComplete = true;
//                         });
//                       },
//                     ),
//                   ),
//
//                   SizedBox(height: screenHeight * 0.03),
//
//                   /// Resend OTP with Timer
//                   Center(
//                     child: _remainingSeconds > 0
//                         ? Text(
//                       "Resend OTP in 00:${_remainingSeconds.toString().padLeft(2, '0')}",
//                       style: GoogleFonts.nunito(
//                         fontSize: screenWidth * 0.030,
//                         color: AppColors.darkGrey,
//                       ),
//                     )
//                         : GestureDetector(
//                       onTap: () {
//                         print("Resend OTP tapped");
//                         _startTimer(); // restart timer
//                       },
//                       child: Text(
//                         "Resend OTP",
//                         style: GoogleFonts.nunito(
//                           fontWeight: FontWeight.w600,
//                           fontSize: screenWidth * 0.035,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ),
//                   ),
//
//
//                   const Spacer(),
//
//                   // Verify Button
//                   CustomButton(
//                     text: "Verify OTP",
//                     onTap: isOtpComplete
//                         ? () {
//                       Get.offAllNamed(AppRoutes.dashBoard);
//                     }
//                         : () {}, // disabled if not 6 digit
//                     backgroundColor:
//                     isOtpComplete ? AppColors.primary : AppColors.grey,
//                   ),
//
//                   SizedBox(height: screenHeight * 0.02),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//
//     );
//   }
// }
