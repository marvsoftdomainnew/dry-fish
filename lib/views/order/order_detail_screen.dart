import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/app_colors.dart';
import '../../constants/api_constants.dart';
import '../../viewmodels/order_detaails_controller.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  OrderDetailScreen({super.key, required this.orderId});
  final controller = Get.put(OrderDetailController());

  @override
  Widget build(BuildContext context) {
    controller.fetchOrderDetails(orderId);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.extraLightestPrimary,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Order Detail",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.orderDetails.value == null) {
          return const SizedBox();
        }

        final order = controller.orderDetails.value!.order;
        final orderItems = order.orderItems;

        final subtotal = orderItems.fold<double>(
          0.0,
          (sum, item) => sum + (double.tryParse(item.total) ?? 0),
        );

        const deliveryCharge = 50.0;
        const discount = 30.0;
        final grandTotal = subtotal + deliveryCharge - discount;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Order Info
              _section("Order Info", [
                _info("Order ID", order.orderNumber),
                _info("Order Date", order.createdAt.split("T").first),
                _info("Status", order.orderStatus, color: AppColors.primary),
              ]),
              SizedBox(height: 2.h),

              _section(
                "Items",
                orderItems.map((item) {
                  final image = item.product.image;
                  final imageUrl = image.isNotEmpty
                      ? "${ApiConstants.imageBaseUrl}$image"
                      : "assets/images/banner2.jpg";
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 20.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product ID: ${item.productId}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.8.h),
                              Text(
                                "₹${item.total}  •  Qty: ${item.quantity}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 2.h),

              /// Price Summary
              _section("Price Summary", [
                _info("Subtotal", "₹$subtotal"),
                _info("Delivery", "₹$deliveryCharge"),
                _info("Discount", "-₹$discount"),
                Divider(color: Colors.grey.shade300),
                _info(
                  "Grand Total",
                  "₹$grandTotal",
                  isBold: true,
                  color: AppColors.primary,
                ),
              ]),
            ],
          ),
        );
      }),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 1.h),
          ...children,
        ],
      ),
    );
  }

  Widget _info(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}