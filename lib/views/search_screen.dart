// import 'dart:math';
// import 'package:chavan_brothers/views/products/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../Constants/app_colors.dart';
import '../constants/api_constants.dart';
import '../roots/routes.dart';
import '../viewmodels/category_controller.dart';
import '../widgets/custom_text_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final CategoryController _categoryController = Get.put(CategoryController());

  late AnimationController _animationController;
  late Animation<double> _animation;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });

    // Fetch categories from API
    _categoryController.getCategory();

    // Play entry animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTextAppBar(title: "Search"),
      body: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.2),
              end: Offset.zero,
            ).animate(_animation),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  /// 🔍 Search bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: AppColors.extraLightGrey,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.lightGrey,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        hintText: "Search categories...",
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  /// 🧾 Category Grid
                  Expanded(
                    child: Obx(() {
                      if (_categoryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final filtered = _categoryController.categoryList
                          .where(
                            (c) => c.name!.toLowerCase().contains(searchQuery),
                          )
                          .toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            "No categories found.",
                            style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final category = filtered[index];
                          String imageUrl = category.image != null
                              ? "${ApiConstants.imageBaseUrl}/${category.image}"
                              : "assets/images/p2.png";
                          // fallback image

                          return InkWell(
                            onTap: () {
                              if (category.id != null) {
                                Get.toNamed(
                                  AppRoutes.productScreen,
                                  arguments: {'categoryId': category.id},
                                );
                              } else {
                                Get.snackbar("Error", "Invalid category ID");
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    height: 18.w,
                                    width: 18.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              "assets/images/p2.png",
                                              height: 18.w,
                                              width: 18.w,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Flexible(
                                  child: Text(
                                    category.name ?? "",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
