import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart'; // Add this import

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
// import 'widgets/info_cards.dart';
import 'widgets/shimmer_widget.dart';
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
            double.tryParse(weights[selectedWeightIndex.value].split(" ")[0]) ??
                0.0;

        final total = basePrice * weightValue;

        selectedPrice.value = total;
      } else {
        selectedPrice.value = 0.0;
      }

      isCalculating.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() {
        if (productController.errorMessage.isNotEmpty) {
          return Center(child: Text(productController.errorMessage.value));
        }

        final product = productController.productDetails.value;
        final price = product?.price?.toString() ?? 0.0;

        // final image = "${ApiConstants.imageBaseUrl}${product.image}";
        // final image1 = "${ApiConstants.imageBaseUrl}${product.image1}";

        cuts = [
          {
            "name": "Fry Cut",
            "price": price,
            "image": "assets/images/banner2.jpg",
          },
          {
            "name": "Curry Cut",
            "price": price,
            "image": "assets/images/banner2.jpg",
          },
        ];
        return Stack(
          children: [
            _buildScrollContent(h, w, product != null),
            _buildFloatingCartBar()
          ],
        );
      }),
    );
  }

  Widget _buildScrollContent(double screenHeight, double screenWidth, bool hasData) {
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
          _buildSliverAppBar(screenHeight, hasData),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 7.w),
                    _buildProductHeader(hasData),
                    SizedBox(height: 6.w),
                    _buildCutSelection(screenHeight, hasData),
                    SizedBox(height: 6.w),
                    _buildWeightSelection(hasData),
                    const SizedBox(height: 32),
                    buildDescriptionSection(hasData),
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

  Widget _buildSliverAppBar(double screenHeight, bool hasData) {
    final product = productController.productDetails.value;
    
    if (!hasData) {
      return SliverAppBar(
        expandedHeight: screenHeight * 0.28,
        pinned: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: FlexibleSpaceBar(
          background: _buildHeroImageShimmer(),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
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
                product!.name ?? "Unknown Product",
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

  Widget _buildHeroImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          color: Colors.grey,
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
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: false,
      ),
    );
  }

  Widget _buildProductHeader(bool hasData) {
    if (!hasData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            width: 70.w,
            height: 25.sp,
          ),
          SizedBox(height: 1.w),
          ShimmerWidget.rectangular(
            width: 50.w,
            height: 15.sp,
          ),
        ],
      );
    }

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

  Widget buildDescriptionSection(bool hasData) {
    if (!hasData) {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget.rectangular(
              width: 40.w,
              height: 16.sp,
            ),
            const SizedBox(height: 12),
            ShimmerWidget.rectangular(
              width: double.infinity,
              height: 60.sp,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ShimmerWidget.rectangular(
                  width: 30.w,
                  height: 32,
                ),
                const SizedBox(width: 8),
                ShimmerWidget.rectangular(
                  width: 30.w,
                  height: 32,
                ),
              ],
            ),
          ],
        ),
      );
    }

    final product = productController.productDetails.value;
    if (product == null) {
      return const SizedBox.shrink();
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

  Widget _buildCutSelection(double screenHeight, bool hasData) {
    if (!hasData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            width: 40.w,
            height: 16.sp,
          ),
          const SizedBox(height: 8),
          ShimmerWidget.rectangular(
            width: 60.w,
            height: 15.sp,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 22.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 2,
              itemBuilder: (_, i) => Container(
                margin: const EdgeInsets.only(right: 16),
                child: ShimmerWidget.rectangular(
                  width: 35.w,
                  height: 22.h,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
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
                          0.0;
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
  }

  Widget _buildWeightSelection(bool hasData) {
    if (!hasData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            width: 20.w,
            height: 17.sp,
          ),
          const SizedBox(height: 8),
          ShimmerWidget.rectangular(
            width: 40.w,
            height: 15.sp,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(6, (i) => ShimmerWidget.rectangular(
              width: 20.w,
              height: 40,
            )),
          ),
        ],
      );
    }

    return Column(
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
  }

  Widget _buildFloatingCartBar() => Obx(() {
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

    final int finalItems = cartController.cartItems.length + addCount;
    final double finalPrice =
        cartController.totalPrice.value + selectedPrice.value;

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