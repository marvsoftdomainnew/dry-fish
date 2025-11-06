import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/app_colors.dart';

class FloatingCartBarWidget extends StatelessWidget {
  final RxInt totalItems;
  final RxDouble totalPrice;
  final String buttonText;
  final VoidCallback onTap;
  final bool isLoading; // 👈 Added

  const FloatingCartBarWidget({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.buttonText,
    required this.onTap,
    this.isLoading = false, // 👈 Default false
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Obx(() {
      if (totalItems.value == 0) return const SizedBox.shrink();

      return SafeArea(
        minimum: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: bottomPadding + 16,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: isLoading ? null : onTap, // 👈 Disable tap during loading
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLoading ? AppColors.successGreen : AppColors.successGreen, // 👈 Dim color while loading
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Left: Items & Price
                  Row(
                    children: [
                      Text(
                        "${totalItems.value} items |",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₹${totalPrice.value.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  /// Right: Button / Loader
                  isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Row(
                    children: [
                      Text(
                        buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
