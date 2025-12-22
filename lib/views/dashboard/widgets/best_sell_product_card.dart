import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
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

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Get.toNamed(
            AppRoutes.productDetail,
            arguments: {'product_id': productId},
          );
        },
        child: Container(
          width: w * 0.58,
          margin: EdgeInsets.only(right: 4.w, bottom: 2.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🖼 Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.network(
                  imageUrl,
                  height: h * 0.17,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    "assets/images/banner2.jpg",
                    height: h * 0.17,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// 📝 Content Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      /// Subtitle (optional)
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: w * 0.028,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],

                      /// Push price to bottom
                      const Spacer(),

                      /// 💰 Price (ALWAYS BOTTOM)
                      Text(
                        "₹$price",
                        style: GoogleFonts.nunito(
                          fontSize: w * 0.040,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  // @override
  // Widget build(BuildContext context) {
  //   final w = MediaQuery.of(context).size.width;
  //   final h = MediaQuery.of(context).size.height;

  //   return InkWell(
  //     borderRadius: BorderRadius.circular(12),
  //     onTap: () {
  //       /// 👇 Print product ID when tapped
  //       print("🟢 Product tapped → ID: $productId");

  //       /// Navigate to detail page
  //       Get.toNamed(
  //         AppRoutes.productDetail,
  //         arguments: {
  //           // 'productName': title,
  //           // 'imageUrl': imageUrl,
  //           // 'price': double.tryParse(price) ?? 0.0,
  //           'product_id': productId,
  //         },
  //       );
  //     },
  //     child: Container(
  //       width: w * 0.58,
  //       margin: EdgeInsets.only(right: w * 0.04),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           /// 🔹 Product Image
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(12),
  //             child: Image.network(
  //               imageUrl,
  //               height: h * 0.16,
  //               width: double.infinity,
  //               fit: BoxFit.cover,
  //               errorBuilder: (_, __, ___) => Image.asset(
  //                 "assets/images/banner2.jpg",
  //                 height: h * 0.16,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),

  //           /// 🔹 Product Info
  //           Padding(
  //             padding: EdgeInsets.all(w * 0.025),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   title,
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: GoogleFonts.nunito(
  //                     fontSize: w * 0.039,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 SizedBox(height: h * 0.005),
  //                 Text(
  //                   subtitle,
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: GoogleFonts.nunito(
  //                     fontSize: w * 0.028,
  //                     color: AppColors.darkGrey,
  //                   ),
  //                 ),
  //                 SizedBox(height: h * 0.008),
  //                 Text(
  //                   "₹$price",
  //                   style: GoogleFonts.nunito(
  //                     fontSize: w * 0.035,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
