import 'dart:async';
import 'package:chavan_brothers/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_keys.dart';
import '../roots/routes.dart';
import '../services/sharedpreferences_service.dart';
import '../viewmodels/internet_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
    _initialize();
  }

  Future<void> _initialize() async {
    final internetController = Get.find<InternetController>();

    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferencesService.getInstance();
    bool isLogged = prefs.getBool(AppKeys.isLogin) ?? false;

    if (!isLogged) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      Get.offAllNamed(AppRoutes.dashBoard);
    }
    internetController.showPopup = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.60;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/images/bgImages/splashBg.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageSize * 0.25),
                  child: Image.asset(
                    'assets/images/splashlogo.png',
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
