import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../Constants/app_colors.dart';
import '../../constants/api_constants.dart';
import '../../viewmodels/order_history_controller.dart';
import '../../widgets/custom_text_app_bar.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  final bool showAppBar;

  const OrderHistoryScreen({super.key, this.showAppBar = true});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final orderListController = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: AppColors.extraLightestPrimary,
              elevation: 1,
              centerTitle: true,
              title: const Text(
                "Order History",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : const CustomTextAppBar(title: "Orders"),

      body: Obx(() {
        if (orderListController.isLoading.value) {
          return _buildShimmerLoading();
        }

        if (orderListController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              orderListController.errorMessage.value,
              style: TextStyle(fontSize: 15.sp, color: Colors.grey),
            ),
          );
        }

        final orders = orderListController.orders.reversed.toList();

        return ListView.builder(
          padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12.h),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final orderDate = order.createdAt.split("T").first;
            final status = order.orderStatus.capitalizeFirst ?? "";
            final total = order.totalAmount.toStringAsFixed(0);

            return InkWell(
              onTap: () {
                Get.to(() => OrderDetailScreen(orderId: order.id.toString()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Shipment ID: ${order.orderNumber}",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => OrderDetailScreen(
                                          orderId: order.id.toString(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                orderDate,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    getStatusIcon(status),
                                    color: getStatusColor(status),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: getStatusColor(status),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "₹$total",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: List.generate(order.orderItems.length, (i) {
                          final item = order.orderItems[i];
                          final image = item.product?.image ?? "";
                          final imageUrl = image.isNotEmpty
                              ? "${ApiConstants.imageBaseUrl}$image"
                              : "assets/images/banner2.jpg";

                          final isLast =
                              i ==
                              order.orderItems.length -
                                  1; // ✅ to avoid divider after last item

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  top: 8,
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// IMAGE LEFT
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          imageUrl,
                                          width: 24.w,
                                          height: 7.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),

                                      /// TEXT RIGHT
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            /// NAME
                                            Text(
                                              item.product?.name ??
                                                  "Unknown Product",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),

                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black87,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${item.weight ?? '--'} KG",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: "   |   ",
                                                  ),
                                                  TextSpan(
                                                    text: "₹${item.price}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: "   |   ",
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "Qty: ${item.quantity}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if (!isLast)
                                Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                  height: 12,
                                ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12.h),
      itemCount: 3, // Show 3 shimmer orders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order header shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 16,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 18,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Order items shimmer (show 2 items per order)
                  Column(
                    children: List.generate(2, (i) {
                      final isLast = i == 1; // For divider logic
                      
                      return Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image shimmer
                                Container(
                                  width: 24.w,
                                  height: 7.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                
                                // Text content shimmer
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            height: 16,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            height: 16,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            height: 16,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          if (!isLast)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              height: 1,
                              color: Colors.grey[300],
                            ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return AppColors.confirmGreen;
      case "cancelled":
        return AppColors.primary;
      case "pending":
      case "processing":
        return AppColors.gold;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return Icons.check_circle;
      case "cancelled":
        return Icons.cancel;
      case "pending":
      case "processing":
        return Icons.access_time;
      default:
        return Icons.info;
    }
  }
}