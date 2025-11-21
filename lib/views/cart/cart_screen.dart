import 'package:dry_fish/views/cart/widgets/floating_cart_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/app_colors.dart';
import '../../constants/api_constants.dart';
import '../../roots/routes.dart';
import '../../utils/toast_util.dart';
import '../../viewmodels/cart_item_controller.dart';
import '../../viewmodels/increase_quantity_controller.dart';
import '../../viewmodels/reduce_quantity_controller.dart';
import '../../viewmodels/remove_cartitem_controller.dart';
import '../../widgets/custom_text_app_bar.dart';

class CartScreen extends StatefulWidget {
  final bool showAppBar;

  const CartScreen({super.key, this.showAppBar = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartItemController cartitemController = Get.find<CartItemController>();
  final RemoveCartItemController removeCartItemController = Get.put(
    RemoveCartItemController(),
  );
  final ReduceQuantityController reduceQuantityController = Get.put(
    ReduceQuantityController(),
  );
  final IncreaseQuantityController increaseQuantityController = Get.put(
    IncreaseQuantityController(),
  );

  /// 🟢 Map to track which item is loading
  final RxMap<String, bool> removeLoading = <String, bool>{}.obs;
  final RxMap<String, bool> increaseLoading = <String, bool>{}.obs;
  final RxMap<String, bool> decreaseLoading = <String, bool>{}.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartitemController.fetchItems();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // screen visible hote hi every time call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartitemController.fetchItems();
    });
  }

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
                "Cart",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back, color: Colors.black),
              //   onPressed: () => Navigator.pop(context),
              // ),
              iconTheme: IconThemeData(color: AppColors.black),
            )
          : const CustomTextAppBar(title: "Cart"),
      body: Obx(() {
        print("🔥 Total Price: ${cartitemController.totalPrice.value}");
        print("🟦 Total Items: ${cartitemController.totalItems.value}");

        if (cartitemController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartitemController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final cartItems = cartitemController.cartItems;

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                      bottom: 12.h,
                    ),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final id = item.id.toString();
                      final imageUrl = item.product.image.isNotEmpty
                          ? "${ApiConstants.imageBaseUrl}${item.product.image}"
                          : "assets/images/banner2.jpg";

                      return Obx(() {
                        final isRemoveLoading = removeLoading[id] ?? false;

                        final isIncLoading = increaseLoading[id] ?? false;
                        final isDecLoading = decreaseLoading[id] ?? false;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        imageUrl,
                                        width: 130,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.image, size: 50),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.name,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
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
                                          const SizedBox(height: 6),
                                          Text(
                                            "₹${item.total}",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Divider(height: 1, thickness: 1),

                              /// ✅ Quantity & Remove Section
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () async {
                                        removeLoading[id] = true;
                                        await removeCartItemController
                                            .removeCartItem(id);
                                        removeLoading[id] = false;

                                        if (removeCartItemController
                                            .successMessage
                                            .value
                                            .isNotEmpty) {
                                          cartitemController.cartItems.removeAt(
                                            index,
                                          );
                                          cartitemController.updateTotals();
                                        } else {
                                          ToastUtil.showError(
                                            removeCartItemController
                                                .errorMessage
                                                .value,
                                          );
                                        }
                                      },
                                      icon: isRemoveLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.delete_outline,
                                              size: 18,
                                            ),
                                      label: const Text("Remove"),
                                    ),

                                    /// Quantity buttons
                                    Row(
                                      children: [
                                        // – Button
                                        IconButton(
                                          onPressed: isDecLoading
                                              ? null
                                              : () async {
                                                  if (item.quantity > 0) {
                                                    decreaseLoading[id] = true;
                                                    final oldQty =
                                                        item.quantity;
                                                    item.quantity--;

                                                    final double price =
                                                        item.price;
                                                    item.total =
                                                        price * item.quantity;
                                                    if (item.quantity == 0) {
                                                      cartitemController
                                                          .cartItems
                                                          .removeAt(index);
                                                      cartitemController
                                                          .updateTotals();
                                                    }
                                                    item.total =
                                                        price * item.quantity;

                                                    cartitemController.update();

                                                    await reduceQuantityController
                                                        .reduceQuantity(id);

                                                    decreaseLoading[id] = false;

                                                    if (reduceQuantityController
                                                        .isSuccess
                                                        .isTrue) {
                                                      cartitemController
                                                          .updateTotals();
                                                    } else {
                                                      item.quantity = oldQty;
                                                      final double price =
                                                          double.tryParse(
                                                            item.total
                                                                .toString(),
                                                          ) ??
                                                          0.0;
                                                      item.total =
                                                          price * item.quantity;

                                                      cartitemController
                                                          .update();
                                                      ToastUtil.showError(
                                                        reduceQuantityController
                                                            .message
                                                            .value,
                                                      );
                                                    }
                                                  }
                                                },
                                          icon: isDecLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Icon(Icons.remove),
                                        ),

                                        Text("${item.quantity}"),

                                        // + Button
                                        IconButton(
                                          onPressed: isIncLoading
                                              ? null
                                              : () async {
                                                  increaseLoading[id] = true;
                                                  final oldQty = item.quantity;
                                                  item.quantity++;

                                                  final double price =
                                                      item.price;
                                                  item.total =
                                                      price * item.quantity;

                                                  cartitemController.update();

                                                  await increaseQuantityController
                                                      .increaseQuantity(id);

                                                  increaseLoading[id] = false;

                                                  if (increaseQuantityController
                                                      .isSuccess
                                                      .isTrue) {
                                                    cartitemController
                                                        .updateTotals(); // ADD THIS
                                                  } else {
                                                    item.quantity = oldQty;
                                                    final double price =
                                                        double.tryParse(
                                                          item.total.toString(),
                                                        ) ??
                                                        0.0;
                                                    item.total =
                                                        price * item.quantity;

                                                    cartitemController.update();
                                                    ToastUtil.showError(
                                                      increaseQuantityController
                                                          .message
                                                          .value,
                                                    );
                                                  }
                                                },
                                          icon: isIncLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            // print('Total Price: ${cartitemController.totalPrice}'),

            /// ✅ Floating Checkout Bar
            FloatingCartBarWidget(
              totalItems: cartitemController.totalItems,
              totalPrice: cartitemController.totalPrice,
              buttonText: "Checkout",
              onTap: () => Get.toNamed(AppRoutes.Checkout),
            ),
          ],
        );
      }),
    );
  }
}
