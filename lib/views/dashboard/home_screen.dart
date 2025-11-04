import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/api_constants.dart';
import '../../Constants/app_colors.dart';
import '../../roots/routes.dart';
import '../../viewmodels/cart_item_controller.dart';
import '../../viewmodels/category_controller.dart';
import '../../viewmodels/products_controller.dart';
import '../cart/widgets/floating_cart_bar.dart';
import 'widgets/carousel_banner.dart';
import 'widgets/best_sell_product_card.dart';
import 'widgets/category_grid.dart';
import 'widgets/review_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CartItemController cartController = Get.put(CartItemController());
  final CategoryController categoryController = Get.put(CategoryController());
  final ProductsController productsController = Get.put(ProductsController());

  final RxInt carouselIndex = 0.obs;

  final List<String> carouselItems = [
    "assets/images/banner2.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner2.jpg",
  ];

  final List<Map<String, dynamic>> reviews = [
    {"name": "Amit Sharma", "rating": 5, "comment": "Excellent quality and super fresh! Delivery was quick too."},
    {"name": "Priya Verma", "rating": 4, "comment": "Good taste and hygiene. Packaging could be better."},
    {"name": "Rahul Singh", "rating": 5, "comment": "Loved it! The fish was fresh and portion size perfect."},
    {"name": "Sneha Iyer", "rating": 4, "comment": "Great variety, definitely ordering again!"},
  ];

  @override
  void initState() {
    super.initState();
    productsController.getProducts();
    categoryController.getCategory();
    cartController.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.01),

                // 🔸 Carousel Banner
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: CarouselBanner(
                    items: carouselItems,
                    carouselIndex: carouselIndex,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // 🔸 Bestsellers Section
                _buildSectionTitle("Bestsellers", "Most popular products near you!"),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03,top: 10),
                  child: Obx(() {
                    if (productsController.isLoading.value) {
                      return _buildShimmerList(screenHeight, screenWidth);
                    }
                    if (productsController.productList.isEmpty) {
                      return _buildEmptyText("No bestsellers found", screenWidth, screenHeight);
                    }

                    final products = productsController.productList;
                    return SizedBox(
                      height: screenHeight * 0.29,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final imageUrl = product.image != null
                              ? "${ApiConstants.imageBaseUrl}${product.image}"
                              : "assets/images/banner2.jpg";
                          return BestSellProductCard(
                            title: product.name ?? "",
                            subtitle: product.description ?? "",
                            imageUrl: imageUrl,
                            price: "${product.price ?? '0'}",
                            productId: product.id.toString(),
                          );
                        },
                      ),
                    );
                  }),
                ),

                // 🔸 Shop by Category Section
                _buildSectionTitle("Shop by category", "Freshest meats and much more!"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: CategoryGrid(controller: categoryController),
                ),

                // 🔸 Customer Reviews Section
                _buildSectionTitle("Customer Reviews", "What our customers say about us"),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  height: screenHeight * 0.20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    itemCount: reviews.length,
                    itemBuilder: (_, i) => ReviewCard(review: reviews[i]),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),

          // 🔸 Floating Cart
          FloatingCartBarWidget(
            totalItems: cartController.totalItems,
            totalPrice: cartController.totalPrice,
            buttonText: "View cart",
            onTap: () => Get.toNamed(AppRoutes.cart),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.nunito(
                  fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: AppColors.black)),
          Text(subtitle,
              style: GoogleFonts.nunito(
                  fontSize: screenWidth * 0.035, color: AppColors.darkGrey)),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildShimmerList(double screenHeight, double screenWidth) => SizedBox(
    height: screenHeight * 0.30,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        width: screenWidth * 0.58,
        margin: EdgeInsets.only(right: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  Widget _buildEmptyText(String text, double screenWidth, double screenHeight) => SizedBox(
    height: screenHeight * 0.1,
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.nunito(color: AppColors.darkGrey, fontSize: screenWidth * 0.035),
      ),
    ),
  );
}

