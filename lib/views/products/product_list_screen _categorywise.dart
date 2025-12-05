import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/api_constants.dart';
import '../../roots/routes.dart';
import '../../viewmodels/category_controller.dart';
import '../../viewmodels/products_by_category_controller.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final int categoryId;
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProductsByCategoryController productsByCategoryController = Get.put(
    ProductsByCategoryController(),
  );

  @override
  void initState() {
    super.initState();
    // Initialize categoryId from Get.arguments safely
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null || args['categoryId'] == null) {
      categoryId = 0;
    } else {
      categoryId = args['categoryId'];
    }
    print("categoryId :: ${categoryId}");

    ///  Fetch all categories
    categoryController.getCategory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ///  After fetching, set selected category
      if (categoryController.categoryList.isNotEmpty) {
        productsByCategoryController.setInitialCategory(categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ratio = screenWidth / (screenHeight * 0.78);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.extraLightestPrimary,
        elevation: 1,
        centerTitle: true,
        title: Obx(() {
          if (categoryController.categoryList.isEmpty) return const Text("");
          if (categoryController.isLoading.value) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(width: 100, height: 24, color: Colors.grey[400]),
            );
          }
          final cat =
              categoryController.categoryList[productsByCategoryController
                  .selectedCategoryIndex
                  .value];
          return Text(
            cat.name ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          );
        }),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          /// 🟩 Left Category List
          Container(
            width: screenWidth * 0.25,
            color: AppColors.bgColor,
            child: Obx(() {
              if (categoryController.isLoading.value) {
                return _buildCategoryShimmer(screenWidth);
              }

              return ListView.builder(
                itemCount: categoryController.categoryList.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isSelected =
                        productsByCategoryController
                            .selectedCategoryIndex
                            .value ==
                        index;
                    final cat = categoryController.categoryList[index];
                    return InkWell(
                      onTap: () {
                        productsByCategoryController.selectCategory(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.white
                              : Colors.transparent,
                          border: Border(
                            left: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            ClipOval(
                              child: cat.image != null
                                  ? Image.network(
                                      "${ApiConstants.imageBaseUrl}/${cat.image}",
                                      height: screenWidth * 0.12,
                                      width: screenWidth * 0.12,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/p2.png",
                                      height: screenWidth * 0.12,
                                      width: screenWidth * 0.12,
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat.name ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * 0.030,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),

          Expanded(
            child: Obx(() {
              if (productsByCategoryController.isLoadingProducts.value) {
                return _buildProductGridShimmer(
                  screenWidth,
                  screenHeight,
                  ratio,
                );
              }

              if (productsByCategoryController.products.isEmpty) {
                return noProductsFound();
              }

              final products = productsByCategoryController.products;
              return GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.02),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.03,
                  childAspectRatio: ratio,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () => Get.toNamed(
                      AppRoutes.productDetail,
                      arguments: {'product_id': product.id},
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: product.image != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "${ApiConstants.imageBaseUrl}/${product.image}",
                                    height: screenHeight * 0.14,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          "assets/images/banner2.jpg",
                                          height: screenHeight * 0.14,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                  )
                                : Image.asset(
                                    "assets/images/banner2.jpg",
                                    height: screenHeight * 0.14,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.025),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                  SizedBox(height: screenWidth * 0.002),
                                  Text(
                                    product.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.darkGrey,
                                      fontSize: screenWidth * 0.030,
                                    ),
                                  ),
                                  SizedBox(height: screenWidth * 0.013),
                                  Text(
                                    "₹${product.price ?? '0'}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.036,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget noProductsFound() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🐟 Image
          Image.asset(
            "assets/images/empty.png",
            width: 15.h,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 10),

          // ❗Sorry!
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey.shade600,
                size: 26,
              ),
              const SizedBox(width: 6),
              Text(
                "Sorry!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // No Product Found...
          Text(
            "No Product Found...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "You Can Try Our Different Product...",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildCategoryShimmer(double screenWidth) {
    return ListView.builder(
      itemCount: 6, // Show 6 shimmer categories
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                Container(
                  height: screenWidth * 0.12,
                  width: screenWidth * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 16,
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: screenWidth * 0.10,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductGridShimmer(
    double screenWidth,
    double screenHeight,
    double ratio,
  ) {
    return GridView.builder(
      padding: EdgeInsets.all(screenWidth * 0.02),
      itemCount: 6, // Show 6 shimmer products
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth * 0.03,
        childAspectRatio: ratio,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: screenHeight * 0.14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                // Content area
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title placeholder
                        Container(
                          height: 18,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.002),

                        // Description placeholder line 1
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 4),

                        // Description placeholder line 2
                        Container(
                          height: 14,
                          width: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.013),

                        // Price placeholder
                        Container(
                          height: 20,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
