import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Constants/app_colors.dart';
import '../../../roots/routes.dart';

class BestSellProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String price;
  final String productId;

  const BestSellProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        /// 👇 Print product ID when tapped
        print("🟢 Product tapped → ID: $productId");

        /// Navigate to detail page
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {
            // 'productName': title,
            // 'imageUrl': imageUrl,
            // 'price': double.tryParse(price) ?? 0.0,
            'product_id': productId,
          },
        );
      },
      child: Container(
        width: w * 0.58,
        margin: EdgeInsets.only(right: w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: h * 0.16,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  "assets/images/banner2.jpg",
                  height: h * 0.16,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// 🔹 Product Info
            Padding(
              padding: EdgeInsets.all(w * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: w * 0.039,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: h * 0.005),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: w * 0.028,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  Text(
                    "₹$price",
                    style: GoogleFonts.nunito(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
