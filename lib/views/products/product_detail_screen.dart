import 'package:carousel_slider/carousel_slider.dart';
import 'package:dry_fish/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Constants/app_colors.dart';
import '../../models/requests/add_to_cart_request.dart';
import '../../repositories/addtocart_repository.dart';
import '../../roots/routes.dart';
import '../../viewmodels/add_to_cart_controller.dart';
import '../../viewmodels/cart_item_controller.dart';
import '../cart/widgets/floating_cart_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {

  final CartItemController cartController = Get.put(CartItemController());
  final AddToCartController addToCartController = Get.put(AddToCartController(repository: AddtocartRepository()));

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final RxInt selectedCutIndex = (-1).obs;
  final RxInt selectedWeightIndex = (-1).obs;
  final RxDouble selectedPrice = 0.0.obs;

  bool _isCollapsed = false;
  late String productName;
  late String imageUrl;
  late int productId;
  late double price;

  List<Map<String, dynamic>> cuts = [];

  static const List<String> weights = [
    "0.25 kg", "0.5 kg", "1 kg", "1.5 kg", "2 kg", "2.5 kg",
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    productName = args['productName'] ?? 'Unknown Product';
    imageUrl = args['imageUrl'] ?? '';
    price = (args['price'] is double)
        ? args['price']
        : double.tryParse(args['price'].toString()) ?? 0.0;
    appLog(" aakshdhfk :: ${price}");
    productId = int.tryParse(args['product_id'].toString()) ?? 0;
    cuts = [
      {"name": "Fry Cut", "price": price, "image": "assets/images/banner2.jpg"},
      {"name": "Curry Cut", "price": price, "image": "assets/images/banner2.jpg"},
    ];

    _animationController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
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
    if (selectedCutIndex.value != -1 && selectedWeightIndex.value != -1) {
      final cut = cuts[selectedCutIndex.value];
      final basePrice = cut["price"].toDouble();
      final weightValue = double.parse(weights[selectedWeightIndex.value].split(" ")[0]);
      final total = basePrice * weightValue;
      cartController.totalItems.value = 1;
      cartController.totalPrice.value = total;
      _triggerAddToCart();
    } else {
      cartController.totalItems.value = 0;
      cartController.totalPrice.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          _buildScrollContent(h, w),
          _buildFloatingCartBar(),
        ],
      ),
    );
  }

  Widget _buildScrollContent(double screenHeight, double screenWidth) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll.metrics.axis == Axis.vertical) {
          final collapsed = scroll.metrics.pixels > (screenHeight * 0.28 - kToolbarHeight);
          if (_isCollapsed != collapsed) setState(() => _isCollapsed = collapsed);
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
                    const _DescriptionSection(),
                    const SizedBox(height: 24),
                    _InfoCards(screenWidth: screenWidth),
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

  SliverAppBar _buildSliverAppBar(double screenHeight) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      expandedHeight: screenHeight * 0.28,
      pinned: true,
      backgroundColor:
          _isCollapsed ? AppColors.extraLightestPrimary : Colors.transparent,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        child: _isCollapsed
            ? Text(productName,
                key: const ValueKey("title"),
                style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black),
                overflow: TextOverflow.ellipsis)
            : const SizedBox.shrink(key: ValueKey("empty")),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroImage([imageUrl]),
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: _isCollapsed ? AppColors.black : AppColors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

Widget _buildHeroImage(List<String> imageUrls) {
  return CarouselSlider.builder(
    itemCount: imageUrls.length,
    itemBuilder: (context, index, realIdx) {
      final imageUrl = imageUrls[index];
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
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) =>
                    Image.asset("assets/images/banner2.jpg", fit: BoxFit.cover),
              ),
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
                colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
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


  // Widget _buildHeroImage() {
  //   return Stack(
  //     fit: StackFit.expand,
  //     children: [
  //       Hero(
  //         tag: imageUrl,
  //         child: ClipRRect(
  //           borderRadius:
  //               const BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
  //           child: CachedNetworkImage(
  //             imageUrl: imageUrl,
  //             fit: BoxFit.cover,
  //             placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
  //             errorWidget: (_, __, ___) =>
  //                 Image.asset("assets/images/banner2.jpg", fit: BoxFit.cover),
  //           ),
  //         ),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //           borderRadius:
  //               const BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildProductHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productName,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                  height: 1.2)),
          SizedBox(height: 1.w),
          Text("(Pungus/Keluthi Meen/Assam Vala/Banka Jella/Sheelan)",
              style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500)),
        ],
      );

  Widget _buildCutSelection(double screenHeight) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose Your Cut",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black)),
          const SizedBox(height: 8),
          Text("Select the perfect cut for your cooking needs",
              style: TextStyle(fontSize: 15.sp, color: AppColors.textGrey)),
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
                    selectedPrice.value = selected ? 0.0 : cuts[i]["price"].toDouble();
                    _updateCartTotal();
                  },
                  child: _CutCard(
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
          Text("Weight",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 17.sp, color: AppColors.black)),
          const SizedBox(height: 8),
          Text("Select your preferred weight",
              style: TextStyle(fontSize: 15.sp, color: AppColors.textGrey)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(weights.length, (i) {
              return Obx(() {
                final selected = selectedWeightIndex.value == i;
                return _WeightChip(
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
        if (selectedCutIndex.value == -1 || selectedWeightIndex.value == -1) {
          return const SizedBox.shrink();
        }
        return FloatingCartBarWidget(
          totalItems: cartController.totalItems,
          totalPrice: cartController.totalPrice,
          buttonText: "View Cart",
          onTap: () {
            final cut = cuts[selectedCutIndex.value];
            final weight = weights[selectedWeightIndex.value];
            final basePrice = cut["price"].toDouble();
            final weightVal = double.parse(weight.split(" ")[0]);
            final total = basePrice * weightVal;

            final cartItem = {
              "productName": productName,
              "cutType": cut["name"],
              "weight": weight,
              "pricePerKg": basePrice,
              "mrp": cut["mrp"],
              "quantity": 1,
              "totalPrice": total,
              "image": imageUrl,
            };
            Get.toNamed(AppRoutes.cart, arguments: {"cartItem": cartItem});
          },
        );
      });
}


class _CutCard extends StatelessWidget {
  final Map<String, dynamic> cut;
  final bool isSelected;
  final double height;

  const _CutCard({required this.cut, required this.isSelected, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.white : AppColors.lightGrey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(cut["image"], height: height * 0.12, width: double.infinity, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cut["name"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: const Color(0xFF1E293B))),
                  SizedBox(height: 1.h),
                  Column(
                    children: [
                      Text("${cut["price"]}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: AppColors.black)),
                      // if (cut["mrp"] != null)
                      //   Text("₹${cut["mrp"]}",
                      //       style: TextStyle(
                      //           fontSize: 14.sp,
                      //           color: Colors.grey[500],
                      //           decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _WeightChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.lightGrey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.lighterPrimary,
              width: isSelected ? 1.5 : 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 15.sp,
              color: isSelected ? AppColors.primary : AppColors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500),
        ),
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About This Fish",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.black)),
          const SizedBox(height: 12),
          Text(
            "Our fish are freshly caught and carefully processed to retain quality and taste. Each piece is hand-selected and cleaned with utmost care, ensuring you get the finest quality seafood.",
            style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              _FeatureChip(label: "Fresh Catch", icon: Icons.waves),
              SizedBox(width: 8),
              _FeatureChip(label: "Quality Assured", icon: Icons.verified),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FeatureChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: AppColors.lighterGrey, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.darkGrey),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.darkGrey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _InfoCards extends StatelessWidget {
  final double screenWidth;
  const _InfoCards({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _CardContainer(
          child: Row(
            children: [
              Image(image: AssetImage("assets/images/fassilogo.png"), height: 32),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("FSSAI Certified",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text("Lic. No: 12345678901234",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.verified, color: AppColors.confirmGreen, size: 20),
            ],
          ),
        ),
        SizedBox(height: 12),
        _CardContainer(
          child: Row(
            children: [
              _IconBox(),
              SizedBox(width: 12),
              Expanded(
                child: Text("123 Marine Street, Coastal City, India",
                    style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(color: AppColors.extraLightestPrimary, borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
    );
  }
}
   