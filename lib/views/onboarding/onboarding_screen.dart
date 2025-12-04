import 'package:chavan_brothers/roots/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/app_colors.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onbordImages/o1.jpg",
      "title": "Fresh from the Ocean to Your Plate",
      "subtitle": "Directly sourced, responsibly delivered.",
    },
    {
      "image": "assets/images/onbordImages/o2.jpg",
      "title": "Pure. Sun-dried. Chemical-free.",
      "subtitle": "Only the best catch, selected for you.",
    },
    {
      "image": "assets/images/onbordImages/o3.jpg",
      "title": "The Chavan Promise",
      "subtitle": "From the shore to your door, on time.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          /// PageView with image + title + subtitle
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        /// Image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: Image.asset(
                            onboardingData[index]["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenHeight * 0.60,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        /// Title
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                          ),
                          child: Text(
                            onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.055,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        /// Subtitle
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                          ),
                          child: Text(
                            onboardingData[index]["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                /// Skip button (status bar + 10 se niche)
                Positioned(
                  top: statusBarHeight + 10,
                  right: 16,
                  child: CustomButton(
                    text: "Skip",
                    onTap: () {
                      Get.offAllNamed(AppRoutes.login);
                    },
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.045,
                    borderRadius: 8,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    textColor: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.03),

          /// Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                width: currentIndex == index
                    ? screenWidth * 0.08
                    : screenWidth * 0.015,
                height: 6,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.primary
                      : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          /// Bottom button with SafeArea
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                bottom: screenHeight * 0.02,
              ),
              child: CustomButton(
                text: currentIndex == onboardingData.length - 1
                    ? "Get Started"
                    : "Next",
                withShadow: true,
                onTap: () {
                  if (currentIndex == onboardingData.length - 1) {
                    Get.offAllNamed(AppRoutes.login);
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
