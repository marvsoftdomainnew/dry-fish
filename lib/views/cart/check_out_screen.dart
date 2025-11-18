import 'package:dry_fish/Constants/app_colors.dart';
import 'package:dry_fish/constants/api_constants.dart';
import 'package:dry_fish/roots/routes.dart';
import 'package:dry_fish/views/cart/widgets/floating_cart_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/app_colors.dart';
import '../../constants/api_constants.dart';
import '../../constants/app_keys.dart';
import '../../models/requests/place_order_request.dart';
import '../../models/responses/get_addresses_response.dart';
import '../../services/sharedpreferences_service.dart';
import '../../utils/snackbar_util.dart';
import '../../viewmodels/get_address_controller.dart';
import '../../viewmodels/placeorder_controller.dart';
import '../../viewmodels/cart_item_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final double shippingFee = 29;
  final double handlingFee = 4;

  final PlaceOrderController orderController = Get.put(PlaceOrderController());
  final CartItemController cartController = Get.put(CartItemController());
  final GetAddressController getAddressController = Get.put(
    GetAddressController(),
  );
  final TextEditingController instructionsController =
      TextEditingController(); // 👈 Added

  AddressModel? selectedAddress;
  String? currentAddressprefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.fetchItems();
      getAddressController.fetchAddresses();
      // loadCurrentAddress();
    });
  }

  double get subtotal =>
      cartController.cartItems.fold(0, (sum, item) => sum + item.total);

  double get totalAmount => subtotal;

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

      /// 👇 Body + FloatingCartBarWidget combined
      body: Stack(
        children: [
          /// 🧾 Main checkout UI
          Obx(() {
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

            final selectedAddress = getAddressController.selectedAddress;
            final hasAddress = getAddressController.addresses.isNotEmpty;

            final addressText = hasAddress && selectedAddress != null
                ? "${selectedAddress.name}, ${selectedAddress.flat}, ${selectedAddress.street}, ${selectedAddress.city}, ${selectedAddress.state} - ${selectedAddress.zip}"
                : (currentAddressprefs != null &&
                          currentAddressprefs!.isNotEmpty
                      ? currentAddressprefs!
                      : "Add delivery address");

            // final addressText = hasAddress && selectedAddress != null
            //     ? "${selectedAddress.name}, ${selectedAddress.flat}, ${selectedAddress.street}, ${selectedAddress.city}, ${selectedAddress.state} - ${selectedAddress.zip}"
            //     : "Add delivery address";

            final buttonText = hasAddress ? "Change" : "Add";

            final items = cartController.cartItems;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),

                  // 🏠 Address Section
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 2.5.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGrey, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                addressText,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (hasAddress) {
                              final selected = await Get.toNamed(
                                AppRoutes.savedaddresses,
                              );
                              if (selected != null &&
                                  selected is AddressModel) {
                                getAddressController.selectAddress(selected.id);
                              }
                            } else {
                              await Get.toNamed(
                                AppRoutes.newAddress,
                                arguments: {
                                  'model': null,
                                  'currentAddress': currentAddressprefs,
                                },
                              );

                              // await Get.toNamed(
                              //   AppRoutes.newAddress,
                              //   arguments: {
                              //     'currentAddress': currentAddressprefs,
                              //   },
                              // );

                              // await Get.toNamed(
                              //   AppRoutes.newAddress,
                              //   arguments: model,
                              // );
                              getAddressController.fetchAddresses();
                            }
                          },
                          child: Text(
                            buttonText,
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

                  // 🧾 Order Summary
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        final item = items[index];
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
                                  width: 25.w,
                                  height: 9.h,
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${item.weight} KG  |  Qty: ${item.quantity}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Cutting: ${item.cuttingType}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
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

                  SizedBox(height: 2.h),

                  // ✍️ Delivery Instructions
                  Text(
                    "Delivery Instructions",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextField(
                    controller: instructionsController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          "e.g., Please deliver between 5–6 PM or call before delivery",
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Container(
                    padding: EdgeInsets.all(3.w),
                    margin: EdgeInsets.only(top: 1.h, bottom: 16.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      children: [
                        _priceRow("Item Subtotal", subtotal),
                        const Divider(),
                        _priceRow(
                          "Total Amount",
                          totalAmount,
                          isBold: true,
                          color: Colors.green[700],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              return FloatingCartBarWidget(
                totalItems: totalItems.obs,
                totalPrice: totalAmount.obs,
                buttonText: orderController.isLoading.value
                    ? "Placing Order..."
                    : "Place Order",
                isLoading: orderController.isLoading.value,
                onTap: () async {
                  if (orderController.isLoading.value) return;
                  if (cartController.cartItems.isEmpty) return;
                  final selectedAddressId =
                      getAddressController.selectedAddressId.value;
                  final hasAddress = getAddressController.addresses.isNotEmpty;
                  if (!hasAddress || selectedAddressId == 0) {
                    SnackbarUtil.showError(
                      "No Address Selected",
                      "Please add or select a delivery address before placing the order.",
                    );
                    return;
                  }
                  // Show popup dialog first 👇
                  bool? isConfirmed = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      bool isChecked = false;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          final RxBool copied = false.obs;
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text(
                              "Scan to Pay",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/qr.png",
                                  width: 30.h,
                                  height: 30.h,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Q113537306@ybl",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Obx(
                                        () => InkWell(
                                          onTap: () async {
                                            await Clipboard.setData(
                                              const ClipboardData(
                                                text: "Q113537306@ybl",
                                              ),
                                            );
                                            copied.value = true;
                                            Future.delayed(
                                              const Duration(seconds: 1),
                                              () {
                                                if (copied.value)
                                                  copied.value = false;
                                              },
                                            );
                                          },
                                          child: Icon(
                                            copied.value
                                                ? Icons.check_circle
                                                : Icons.copy,
                                            size: 20,
                                            color: copied.value
                                                ? AppColors.confirmGreen
                                                : AppColors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      activeColor: Colors.green,
                                      onChanged: (val) {
                                        setState(() {
                                          isChecked = val ?? false;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        "I confirm that the payment is done.",
                                        style: TextStyle(fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isChecked
                                      ? AppColors.confirmGreen
                                      : AppColors.grey,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: isChecked
                                    ? () => Navigator.pop(context, true)
                                    : null,
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  // If user confirmed payment
                  if (isConfirmed == true) {
                    final prefs = await SharedPreferencesService.getInstance();
                    final latitude = prefs.getDouble(AppKeys.latitude);
                    final longitude = prefs.getDouble(AppKeys.longitude);
                    final selectedAddressId =
                        getAddressController.selectedAddressId.value;

                    final request = PlaceOrderRequest(
                      address: selectedAddressId,
                      latitude: latitude,
                      longitude: longitude,
                      instructions: instructionsController.text,
                    );

                    await orderController.placeOrderCont(request);
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String title,
    double value, {
    bool isBold = false,
    Color? color,
  }) {
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
