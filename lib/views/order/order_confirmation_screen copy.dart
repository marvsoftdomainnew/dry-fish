import 'dart:async';
import 'package:chavan_brothers/roots/routes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/app_colors.dart';
import 'package:get/get.dart';

import '../../constants/api_constants.dart';
import '../../models/responses/placeorder_response.dart';
import '../../viewmodels/cancel_order_controller.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int timerSeconds = 30;
  bool showSuccessAnimation = true;
  Timer? countdownTimer;
  final Order? order = Get.arguments as Order?;
  final CancelOrderController _cancelOrderController = Get.put(
    CancelOrderController(),
  );

  @override
  void initState() {
    super.initState();

    // Start timer countdown
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        setState(() => timerSeconds--);
      } else {
        timer.cancel();
      }
    });

    // Hide animation after it completes (~3s)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => showSuccessAnimation = false);
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void _navigateToOrderHistory() {
    Get.offAllNamed(AppRoutes.dashBoard);
  }

  //
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToOrderHistory();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: showSuccessAnimation
            ? null
            : AppBar(
                elevation: 0,
                backgroundColor: AppColors.lightPrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: _navigateToOrderHistory,
                ),
                title: Text(
                  'Order ID: ${order?.orderNumber ?? '-'}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  Obx(() {
                    // 🔹 Hide button once order is cancelled
                    if (_cancelOrderController.isCancelled.value ||
                        timerSeconds <= 0) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (_cancelOrderController.isLoading.value)
                                  return;

                                bool? confirm = await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Cancel Order?"),
                                    content: const Text(
                                      "Are you sure you want to cancel this order?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm != true) return;

                                await _cancelOrderController.cancelOrder(
                                  order!.id.toString(),
                                );

                                // ✅ Show response
                                if (_cancelOrderController.isCancelled.value) {
                                } else {
                                  Get.snackbar(
                                    "Failed",
                                    _cancelOrderController.message.value,
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              child: Obx(() {
                                return _cancelOrderController.isLoading.value
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${timerSeconds}s',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: showSuccessAnimation
                ? _buildSuccessAnimationView()
                : _buildMainContent(),
          ),
        ),
      ),
    );
  }

  /// --- Success Animation View ---
  Widget _buildSuccessAnimationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/successcheck.json',
            width: 300,
            repeat: false,
          ),
          const SizedBox(height: 16),
          const Text(
            "Order Placed Successfully",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  /// --- Main Screen Content ---
  Widget _buildMainContent() {
    return Container(
      color: AppColors.lighterPrimary.withOpacity(0.1),

      child: Column(
        children: [
          // ---------- PRICE DROP BANNER ----------
          // Container(
          //   height: 190,
          //   decoration: BoxDecoration(
          //     image: const DecorationImage(
          //       image: AssetImage(
          //         'assets/images/offer_banner.png',
          //       ), // 🖼️ your image
          //       fit: BoxFit.cover,
          //     ),
          //     gradient: LinearGradient(
          //       colors: [
          //         AppColors.lightPrimary.withOpacity(0.8),
          //         AppColors.lighterPrimary.withOpacity(0.1),
          //       ],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //   ),
          //   child: const Center(
          //     child: Text(
          //       'PRICE DROP\nSave up to 30%',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: 24,
          //         fontWeight: FontWeight.w800,
          //         color: AppColors.primary,
          //       ),
          //     ),
          //   ),
          // ),

          //        Container(
          //   height: 190,
          //   decoration: BoxDecoration(
          //     image: const DecorationImage(
          //       image: AssetImage('assets/images/offer_banner.png'), // 🖼️ your image
          //       fit: BoxFit.cover,
          //     ),
          //     gradient: LinearGradient(
          //       colors: [
          //         AppColors.lightPrimary.withOpacity(0.8),
          //         AppColors.lighterPrimary.withOpacity(0.1),
          //       ],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //   ),

          // ),

          // ---------- SCROLL AREA ----------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    /// Scheduled Order
                    cardSection(
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order is scheduled',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.sp,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Arriving by tomorrow,\n6 AM - 9 AM',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 112,
                            height: 92,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF4F6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.delivery_dining,
                              size: 44,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Address Section
                    cardSection(
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.black,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${order?.deliveryAddress ?? '-'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Order Summary
                    cardSection(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.receipt_long,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your Order Summary',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.black,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.primary),
                              color: AppColors.white,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F0F4),
                                    borderRadius: BorderRadius.circular(12),
                                    image:
                                        order
                                                ?.orderItems
                                                ?.first
                                                .product
                                                ?.image !=
                                            null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              '${ApiConstants.imageBaseUrl}${order!.orderItems!.first.product!.image!}',
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child:
                                      order?.orderItems?.first.product?.image ==
                                          null
                                      ? const Icon(
                                          Icons.image,
                                          color: AppColors.black,
                                        )
                                      : null,
                                ),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order
                                                ?.orderItems
                                                ?.first
                                                .product
                                                ?.name ??
                                            'Product Name',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${order?.orderItems?.first.quantity ?? 0} qty',
                                        style: TextStyle(
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹ ${order?.orderItems?.first.total?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Footer
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: const [
                          Text(
                            'Happiness Served Fresh',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Deliciously Yours, Fish',
                            style: TextStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable card section
Widget cardSection(Widget child, {EdgeInsetsGeometry? padding}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x11000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}
