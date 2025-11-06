import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                return const Center(child: CircularProgressIndicator());
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
                return const Center(child: CircularProgressIndicator());
              }

              if (productsByCategoryController.products.isEmpty) {
                return const Center(child: Text("No products found"));
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
                      arguments: {
                        'productName': product.name,
                        'imageUrl':
                            "${ApiConstants.imageBaseUrl}${product.image ?? ""}",
                        'price': product.price,
                        'product_id': product.id,
                      },
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
}
