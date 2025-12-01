import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Constants/app_colors.dart';
import '../../constants/api_constants.dart';
import '../../models/requests/add_to_cart_request.dart';
import '../../roots/routes.dart';
import '../../viewmodels/add_to_cart_controller.dart';
import '../../viewmodels/cart_item_controller.dart';
import '../../viewmodels/product_details_controller.dart';
import '../cart/widgets/floating_cart_bar.dart';
import 'widgets/card_container.dart';
import 'widgets/cut_card.dart';
import 'widgets/featureChip.dart';
import 'widgets/info_cards.dart';
import 'widgets/weight_chips.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  final CartItemController cartController = Get.put(CartItemController());
  final AddToCartController addToCartController = Get.put(
    AddToCartController(),
  );
  final ProductDetailsController productController = Get.put(
    ProductDetailsController(),
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final RxInt selectedCutIndex = (-1).obs;
  final RxInt selectedWeightIndex = (-1).obs;
  final RxDouble selectedPrice = 0.0.obs;
  final RxBool isCalculating = false.obs;

  bool _isCollapsed = false;
  late int productId;
  List<Map<String, dynamic>> cuts = [];

  static const List<String> weights = [
    "0.25 kg",
    "0.5 kg",
    "1 kg",
    "1.5 kg",
    "2 kg",
    "2.5 kg",
  ];

  @override
  void initState() {
    super.initState();
    selectedCutIndex.value = -1;
    selectedWeightIndex.value = -1;
    selectedPrice.value = 0.0;
    isCalculating.value = false;
    final args = Get.arguments ?? {};
    productId = int.tryParse(args['product_id'].toString()) ?? 0;
    productController.fetchProductDetails(productId.toString());
    cartController.fetchItems();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.fetchItems();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _triggerAddToCart() async {
    final cut = cuts[selectedCutIndex.value];
    final weight = weights[selectedWeightIndex.value];
    final basePrice = double.tryParse(cut["price"].toString()) ?? 0.0;
    final weightValue = double.tryParse(weight.split(" ")[0]) ?? 0.0;

    final request = AddToCartRequest(
      items: [
        OrderItem(
          productId: productId,
          quantity: 1,
          price: basePrice,
          weight: weightValue,
          cuttingType: cut["name"],
          status: "confirmed",
        ),
      ],
    );
    await addToCartController.addToCart(request);
  }

  void _updateCartTotal() {
  isCalculating.value = true;

  Future.delayed(const Duration(milliseconds: 200), () {
    if (selectedCutIndex.value != -1 && selectedWeightIndex.value != -1) {
      final cut = cuts[selectedCutIndex.value];
      final basePrice = double.tryParse(cut["price"].toString()) ?? 0.0;

      final weightValue =
          double.tryParse(weights[selectedWeightIndex.value].split(" ")[0]) ?? 0.0;

      final total = basePrice * weightValue;

      // ❌ DO NOT UPDATE CART TOTAL HERE
      // cartController.totalItems.value = 1;
      // cartController.totalPrice.value = total;

      selectedPrice.value = total;   // 🟢 ONLY update local price
    } else {
      selectedPrice.value = 0.0;
    }

    isCalculating.value = false;
  });
}


  // void _updateCartTotal() async {
  //   isCalculating.value = true; // 👉 Start Loading

  //   await Future.delayed(const Duration(milliseconds: 300));
  //   // small delay to show loader clearly

  //   if (selectedCutIndex.value != -1 && selectedWeightIndex.value != -1) {
  //     final cut = cuts[selectedCutIndex.value];
  //     final basePrice = double.tryParse(cut["price"].toString()) ?? 0.0;
  //     final weightValue =
  //         double.tryParse(weights[selectedWeightIndex.value].split(" ")[0]) ??
  //         0.0;

  //     final total = basePrice * weightValue;

  //     cartController.totalItems.value = 1;
  //     cartController.totalPrice.value = total;
  //     // _triggerAddToCart();
  //   } else {
  //     cartController.totalItems.value = 0;
  //     cartController.totalPrice.value = 0.0;
  //   }

  //   isCalculating.value = false; // 👉 Stop Loading
  // }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productController.errorMessage.isNotEmpty) {
          return Center(child: Text(productController.errorMessage.value));
        }

        final product = productController.productDetails.value;
        if (product == null) {
          return const Center(child: Text("No product details found"));
        }

        final price = product.price?.toString() ?? 0.0;

        // final image = "${ApiConstants.imageBaseUrl}${product.image}";
        // final image1 = "${ApiConstants.imageBaseUrl}${product.image1}";

        cuts = [
          {
            "name": "Fry Cut",
            "price": price,
            "image":"assets/images/banner2.jpg",
          },
          {
            "name": "Curry Cut",
            "price": price,
            "image": "assets/images/banner2.jpg",
          },
        ];

        return Stack(
          children: [_buildScrollContent(h, w), _buildFloatingCartBar()],
        );
      }),
    );
  }

  Widget _buildScrollContent(double screenHeight, double screenWidth) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll.metrics.axis == Axis.vertical) {
          final collapsed =
              scroll.metrics.pixels > (screenHeight * 0.28 - kToolbarHeight);
          if (_isCollapsed != collapsed)
            setState(() => _isCollapsed = collapsed);
        }
        return false;
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(screenHeight),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 7.w),
                    _buildProductHeader(),
                    SizedBox(height: 6.w),
                    _buildCutSelection(screenHeight),
                    SizedBox(height: 6.w),
                    _buildWeightSelection(),
                    const SizedBox(height: 32),
                    buildDescriptionSection(),
                    const SizedBox(height: 24),
                    InfoCards(screenWidth: screenWidth),
                    SizedBox(height: screenHeight * 0.12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(double screenHeight) {
    final product = productController.productDetails.value;
    if (product == null) {
      return SizedBox.shrink();
    }
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      expandedHeight: screenHeight * 0.28,
      pinned: true,
      backgroundColor: _isCollapsed
          ? AppColors.extraLightestPrimary
          : Colors.transparent,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: _isCollapsed
            ? Text(
                product.name ?? "Unknown Product",
                key: const ValueKey("title"),
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                overflow: TextOverflow.ellipsis,
              )
            : const SizedBox.shrink(key: ValueKey("empty")),
      ),
      flexibleSpace: FlexibleSpaceBar(background: _buildHeroImage()),
      leading: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: _isCollapsed ? AppColors.black : AppColors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    final product = productController.productDetails.value;
    if (product == null) {
      return const SizedBox.shrink();
    }
    final List<String> imageUrls = [
      if (product.image != null && product.image!.isNotEmpty)
        "${ApiConstants.imageBaseUrl}${product.image}",
      if (product.image1 != null && product.image1!.isNotEmpty)
        "${ApiConstants.imageBaseUrl}${product.image1}",
      if (product.image2 != null && product.image2!.isNotEmpty)
        "${ApiConstants.imageBaseUrl}${product.image2}",
    ];
    if (imageUrls.isEmpty) {
      imageUrls.add("assets/images/banner2.jpg");
    }

    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index, realIdx) {
        final imageUrl = imageUrls[index];
        final isNetwork = imageUrl.startsWith("http");

        return Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: imageUrl,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                child: isNetwork
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (_, __, ___) => Image.asset(
                          "assets/images/banner2.jpg",
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(imageUrl, fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.transparent,
                    AppColors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        enlargeCenterPage: false,
      ),
    );
  }

  Widget _buildProductHeader() {
    final product = productController.productDetails.value;

    if (product == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name ?? "Unknown Product",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            height: 1.2,
          ),
        ),
        SizedBox(height: 1.w),
        if ((product.category?.description ?? '').isNotEmpty)
          Text(
            product.description!,
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget buildDescriptionSection() {
    final product = productController.productDetails.value;

    if (product == null) {
      return SizedBox.shrink();
    }
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About This Fish",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "${product.description}",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.darkGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              FeatureChip(label: "Fresh Catch", icon: Icons.waves),
              SizedBox(width: 8),
              FeatureChip(label: "Quality Assured", icon: Icons.verified),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCutSelection(double screenHeight) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Choose Your Cut",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: AppColors.black,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "Select the perfect cut for your cooking needs",
        style: TextStyle(fontSize: 15.sp, color: AppColors.textGrey),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 22.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: cuts.length,
          itemBuilder: (_, i) => Obx(() {
            final selected = selectedCutIndex.value == i;
            return GestureDetector(
              onTap: () {
                selectedCutIndex.value = selected ? -1 : i;
                selectedPrice.value = selected
                    ? 0.0
                    : double.tryParse(cuts[i]["price"].toString()) ??
                          0.0; // ✅ fixed
                _updateCartTotal();
              },

              child: CutCard(
                cut: cuts[i],
                isSelected: selected,
                height: screenHeight,
              ),
            );
          }),
        ),
      ),
    ],
  );

  Widget _buildWeightSelection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Weight",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17.sp,
          color: AppColors.black,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "Select your preferred weight",
        style: TextStyle(fontSize: 15.sp, color: AppColors.textGrey),
      ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(weights.length, (i) {
          return Obx(() {
            final selected = selectedWeightIndex.value == i;
            return WeightChip(
              label: weights[i],
              isSelected: selected,
              onTap: () {
                selectedWeightIndex.value = selected ? -1 : i;
                _updateCartTotal();
              },
            );
          });
        }),
      ),
    ],
  );

  Widget _buildFloatingCartBar() => Obx(() {
    print("🔥 Total Price: ${cartController.totalPrice.value}");
    print("🟦 Total Items: ${cartController.totalItems.value}");
    final bool hasCut = selectedCutIndex.value != -1;
    final bool hasWeight = selectedWeightIndex.value != -1;

    final bool cartHasItems = cartController.cartItems.isNotEmpty;

    if (!cartHasItems && (!hasCut || !hasWeight)) {
      return const SizedBox.shrink();
    }

RxDouble selectedPrice = 0.0.obs;
    int addCount = 0;

    if (hasCut && hasWeight) {
      final cut = cuts[selectedCutIndex.value];
      final weight = weights[selectedWeightIndex.value];

      final basePrice = double.tryParse(cut["price"].toString()) ?? 0.0;
      final weightVal = double.parse(weight.split(" ")[0]);

      selectedPrice.value = basePrice * weightVal;
      addCount = 1;
    }

    // 🟢 UNIQUE ITEM COUNT (correct)
    final int finalItems = cartController.cartItems.length + addCount;

    // 🟢 PRICE
    final double finalPrice = cartController.totalPrice.value + selectedPrice.value;
    print("$finalPrice");
    print("${cartController.totalPrice.value} + $selectedPrice.value");

    return FloatingCartBarWidget(
      totalItems: finalItems.obs,
      totalPrice: finalPrice.obs,
      isLoading: addToCartController.isLoading.value,
      buttonText: hasCut && hasWeight ? "Add to Cart" : "View Cart",

      onTap: () async {
        if (addToCartController.isLoading.value) return;

        if (cartHasItems && !hasCut && !hasWeight) {
          Get.toNamed(AppRoutes.cart);
          return;
        }

        await _triggerAddToCart();
        await cartController.fetchItems();

        selectedCutIndex.value = -1;
        selectedWeightIndex.value = -1;

        Get.toNamed(AppRoutes.cart);
      },
    );
  });
}

  // Widget _buildFloatingCartBar() => Obx(() {
  //   final bool hasCut = selectedCutIndex.value != -1;
  //   final bool hasWeight = selectedWeightIndex.value != -1;
  //   final bool cartHasItems = cartController.cartItems.isNotEmpty;
  //   if (!cartHasItems && (!hasCut || !hasWeight)) {
  //     return const SizedBox.shrink();
  //   }
  //   double selectedProductPrice = 0;
  //   int selectedQty = 0;
  //   if (hasCut && hasWeight) {
  //     final cut = cuts[selectedCutIndex.value];
  //     final weight = weights[selectedWeightIndex.value];

  //     final basePrice = double.tryParse(cut["price"].toString()) ?? 0.0;
  //     final weightVal = double.parse(weight.split(" ")[0]);

  //     selectedProductPrice = basePrice * weightVal;
  //     selectedQty = 1;
  //   }
  //   final int finalItems = cartHasItems
  //       ? cartController.totalItems.value + selectedQty
  //       : selectedQty;

  //   final double finalPrice = cartHasItems
  //       ? cartController.totalPrice.value + selectedProductPrice
  //       : selectedProductPrice;
  //   final String buttonLabel = !cartHasItems || (hasWeight && hasCut)
  //       ? "Add to Cart"
  //       : "View Cart";

  //   return Obx(() {
  //     return FloatingCartBarWidget(
  //       isLoading: addToCartController.isLoading.value || isCalculating.value,
  //       totalItems: finalItems.obs,
  //       totalPrice: finalPrice.obs,
  //       buttonText: buttonLabel,

  //       onTap: () async {
  //         if (addToCartController.isLoading.value) return;

  //         final hasCut = selectedCutIndex.value != -1;
  //         final hasWeight = selectedWeightIndex.value != -1;
  //         final hasSelection = hasCut && hasWeight;
  //         final cartHasItems = cartController.cartItems.isNotEmpty;
  //         if (!cartHasItems && !hasSelection) return;
  //         if (cartHasItems && !hasSelection) {
  //           Get.toNamed(AppRoutes.cart);
  //           return;
  //         }
  //         await _triggerAddToCart();

  //         selectedCutIndex.value = -1;
  //         selectedWeightIndex.value = -1;
  //         selectedPrice.value = 0.0;
  //         cartController.totalItems.value = 0;
  //         cartController.totalPrice.value = 0.0;

  //         Get.toNamed(AppRoutes.cart);
  //       },
  //     );
  //   });
  // });

