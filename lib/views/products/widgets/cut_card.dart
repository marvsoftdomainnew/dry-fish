
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/app_colors.dart';

class CutCard extends StatelessWidget {
  final Map<String, dynamic> cut;
  final bool isSelected;
  final double height;

  const CutCard({
    required this.cut,
    required this.isSelected,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.white
            : AppColors.lightGrey.withOpacity(0.4),
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
            child: Image.asset(
              cut["image"],
              height: height * 0.12,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cut["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Column(
                    children: [
                      Text(
                        "${cut["price"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: AppColors.black,
                        ),
                      ),
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

