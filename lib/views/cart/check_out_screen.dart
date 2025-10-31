import 'package:dry_fish/Constants/app_colors.dart';
import 'package:dry_fish/constants/api_constants.dart';
import 'package:dry_fish/roots/routes.dart';
import 'package:dry_fish/constants/app_keys.dart';
import 'package:dry_fish/models/requests/place_order_request.dart';
import 'package:dry_fish/models/responses/saved_addresses_response.dart';
import 'package:dry_fish/services/sharedpreferences_service.dart';
import 'package:dry_fish/viewmodels/cart_item_controller.dart';
import 'package:dry_fish/viewmodels/placeorder_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final double shippingFee = 29;
  final double handlingFee = 4;

  final cartController = Get.put(CartItemController());
  final orderController = Get.put(PlaceOrderController());

  AddressModel? selectedAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.fetchItems();
    });
  }

  double get subtotal =>
      cartController.cartItems.fold(0, (sum, item) => sum + item.total);

  double get totalAmount => subtotal + shippingFee + handlingFee;

  int get totalItems =>
      cartController.cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.extraLightestPrimary,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final items = cartController.cartItems;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),

              /// ADDRESS SECTION
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.5.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGrey, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 22.sp),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivery Address",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            selectedAddress != null
                                ? "${selectedAddress!.name}, ${selectedAddress!.flat}, ${selectedAddress!.street}, ${selectedAddress!.building}, ${selectedAddress!.locality}, ${selectedAddress!.city}, ${selectedAddress!.state} - ${selectedAddress!.zip}"
                                : "Select delivery address",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selected =
                            await Get.toNamed(AppRoutes.savedaddresses);
                        if (selected != null) {
                          setState(() => selectedAddress = selected);
                        }
                      },
                      child: Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                "Order Summary",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),

              /// CART LIST
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey[300]),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final imageUrl = item.product.image.isNotEmpty
                        ? "${ApiConstants.imageBaseUrl}${item.product.image}"
                        : "assets/images/banner2.jpg";

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 22.w,
                              height: 8.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image, size: 40),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  "${item.product.name} | ${item.product.weight}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Qty: ${item.quantity}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      "₹${item.total.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// TOTAL PRICE BOX
              Container(
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.only(top: 1.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _priceRow("Item Subtotal", subtotal),
                    _priceRow("Shipping", shippingFee),
                    _priceRow("Handling Fee", handlingFee),
                    const Divider(),
                    _priceRow("Total Amount", totalAmount,
                        isBold: true, color: Colors.green[700]),
                  ],
                ),
              ),
            ],
          ),
        );
      }),

      /// PLACE ORDER BUTTON
      bottomNavigationBar: Obx(() {
        return Container(
          margin: EdgeInsets.only(bottom: 4.h, left: 4.w, right: 4.w),
          height: 6.5.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: orderController.isLoading.value
                ? null
                : () async {
                    if (cartController.cartItems.isEmpty) return;

                    final prefs = await SharedPreferencesService.getInstance();
                    final latitude = prefs.getDouble(AppKeys.latitude);
                    final longitude = prefs.getDouble(AppKeys.longitude);

                    final firstItem = cartController.cartItems.first;

                    final request = PlaceOrderRequest(
                      userId: firstItem.userId,
                      recipientName: "John Doe",
                      recipientPhone: "9876543210",
                      deliveryAddress: selectedAddress != null
                          ? "${selectedAddress!.flat}, ${selectedAddress!.street}, ${selectedAddress!.building}, ${selectedAddress!.locality}"
                          : "Not Selected",
                      deliveryCity: selectedAddress?.city ?? "",
                      deliveryState: selectedAddress?.state ?? "",
                      deliveryPostcode: selectedAddress?.zip ?? "",
                      totalAmount: totalAmount,
                      paymentStatus: "paid",
                      orderStatus: "dispatched",
                      dispatchedAt: DateTime.now().toString(),
                      deliveredAt: null,
                      notes: "Handle with care.",
                      latitude: latitude,
                      longitude: longitude,
                    );

                    await orderController.placeOrderCont(request);
                  },
            child: orderController.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$totalItems Items | ₹${totalAmount.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Place Order",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _priceRow(String title, double value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          "₹${value.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
