import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/api_constants.dart';
import '../../Constants/app_colors.dart';
import '../../constants/app_keys.dart';
import '../../roots/routes.dart';
import '../../services/sharedpreferences_service.dart';
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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final CategoryController categoryController = Get.find();
  final ProductsController productsController = Get.find();
  final CartItemController cartController = Get.find();
final RxBool isLoggedIn = false.obs;

  final RxInt carouselIndex = 0.obs;

  final List<String> carouselItems = [
    "assets/images/banner2.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner2.jpg",
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Amit Sharma",
      "rating": 5,
      "comment": "Excellent quality and super fresh! Delivery was quick too.",
    },
    {
      "name": "Priya Verma",
      "rating": 4,
      "comment": "Good taste and hygiene. Packaging could be better.",
    },
    {
      "name": "Rahul Singh",
      "rating": 5,
      "comment": "Loved it! The fish was fresh and portion size perfect.",
    },
    {
      "name": "Sneha Iyer",
      "rating": 4,
      "comment": "Great variety, definitely ordering again!",
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLoginStatus();
  }

Future<void> _checkLoginStatus() async {
  final prefs = await SharedPreferencesService.getInstance();
  final logged = prefs.getBool(AppKeys.isLogin) ?? false;

  isLoggedIn.value = logged;

  if (logged) {
    cartController.fetchItems();
  }
}


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isLoggedIn.value) {
      cartController.fetchItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  _animatedSection(
                    delay: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CarouselBanner(
                        items: carouselItems,
                        carouselIndex: carouselIndex,
                      ),
                    ),
                  ),

                  _animatedSection(
                    delay: 150,
                    child: _buildSectionTitle(
                      "Shop by category",
                      "Freshest meats & daily essentials",
                    ),
                  ),

                  _animatedSection(
                    delay: 250,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: CategoryGrid(controller: categoryController),
                    ),
                  ),

                  _animatedSection(
                    delay: 350,
                    child: _buildSectionTitle(
                      "Bestsellers",
                      "Most loved products near you",
                    ),
                  ),

                  _animatedSection(
                    delay: 450,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Obx(() {
                        if (productsController.isLoading.value) {
                          return _buildShimmerList(screenHeight, screenWidth);
                        }

                        if (productsController.productList.isEmpty) {
                          return _buildEmptyText(
                            "No bestsellers found",
                            screenWidth,
                            screenHeight,
                          );
                        }

                        return SizedBox(
                          height: screenHeight * 0.32,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productsController.productList.length,
                            itemBuilder: (context, index) {
                              final product =
                                  productsController.productList[index];
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
                  ),

                  _animatedSection(
                    delay: 600,
                    child: _buildSectionTitle(
                      "Customer Reviews",
                      "What people love about us",
                    ),
                  ),

                  _animatedSection(
                    delay: 700,
                    child: SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 14),
                        itemCount: reviews.length,
                        itemBuilder: (_, i) => ReviewCard(review: reviews[i]),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            /// Floating Cart
            Obx(() {
              if (!isLoggedIn.value || cartController.totalItems.value == 0) {
                return const SizedBox();
              }
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                left: 0,
                right: 0,
                bottom: 12,
                child: FloatingCartBarWidget(
                  totalItems: cartController.totalItems,
                  totalPrice: cartController.totalPrice,
                  buttonText: "View Cart",
                  onTap: () => Get.toNamed(AppRoutes.cart),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _animatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween<double>(begin: 30, end: 0),
      curve: Curves.easeOut,
      builder: (_, double value, __) {
        return Opacity(
          opacity: 1 - (value / 30),
          child: Transform.translate(offset: Offset(0, value), child: child),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.nunito(
              fontSize: screenWidth * 0.035,
              color: AppColors.darkGrey,
            ),
          ),
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

  Widget _buildEmptyText(
    String text,
    double screenWidth,
    double screenHeight,
  ) => SizedBox(
    height: screenHeight * 0.1,
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: AppColors.darkGrey,
          fontSize: screenWidth * 0.035,
        ),
      ),
    ),
  );
}





    // return Scaffold(
    //   backgroundColor: AppColors.bgColor,
    //   body: Stack(
    //     children: [
    //       SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(height: screenHeight * 0.01),
    //             Padding(
    //               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
    //               child: CarouselBanner(
    //                 items: carouselItems,
    //                 carouselIndex: carouselIndex,
    //               ),
    //             ),
    //             SizedBox(height: screenHeight * 0.02),

    //             _buildSectionTitle(
    //               "Shop by category",
    //               "Freshest meats and much more!",
    //             ),
    //             Padding(
    //               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
    //               child: CategoryGrid(controller: categoryController),
    //             ),
    //             _buildSectionTitle(
    //               "Bestsellers",
    //               "Most popular products near you!",
    //             ),
    //             Padding(
    //               padding: EdgeInsets.only(left: screenWidth * 0.03, top: 10),
    //               child: Obx(() {
    //                 if (productsController.isLoading.value) {
    //                   return _buildShimmerList(screenHeight, screenWidth);
    //                 }
    //                 if (productsController.productList.isEmpty) {
    //                   return _buildEmptyText(
    //                     "No bestsellers found",
    //                     screenWidth,
    //                     screenHeight,
    //                   );
    //                 }

    //                 final products = productsController.productList;
    //                 return SizedBox(
    //                   height: screenHeight * 0.29,
    //                   child: ListView.builder(
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: products.length,
    //                     itemBuilder: (context, index) {
    //                       final product = products[index];
    //                       final imageUrl = product.image != null
    //                           ? "${ApiConstants.imageBaseUrl}${product.image}"
    //                           : "assets/images/banner2.jpg";
    //                       return BestSellProductCard(
    //                         title: product.name ?? "",
    //                         subtitle: product.description ?? "",
    //                         imageUrl: imageUrl,
    //                         price: "${product.price ?? '0'}",
    //                         productId: product.id.toString(),
    //                       );
    //                     },
    //                   ),
    //                 );
    //               }),
    //             ),
    //             // Reviews
    //             _buildSectionTitle(
    //               "Customer Reviews",
    //               "What our customers say about us",
    //             ),
    //             SizedBox(height: screenHeight * 0.01),
    //             SizedBox(
    //               height: screenHeight * 0.20,
    //               child: ListView.builder(
    //                 scrollDirection: Axis.horizontal,
    //                 padding: EdgeInsets.only(left: screenWidth * 0.03),
    //                 itemCount: reviews.length,
    //                 itemBuilder: (_, i) => ReviewCard(review: reviews[i]),
    //               ),
    //             ),
    //             SizedBox(height: screenHeight * 0.02),
    //           ],
    //         ),
    //       ),

    //       FloatingCartBarWidget(
    //         totalItems: cartController.totalItems,
    //         totalPrice: cartController.totalPrice,
    //         buttonText: "View cart",
    //         onTap: () => Get.toNamed(AppRoutes.cart),
    //       ),
    //     ],
    //   ),
    // );