import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Constants/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final String address;
  final String street;
  final double screenWidth;
  final double screenHeight;
  final double statusBarHeight;

  const DashboardHeader({
    Key? key,
    required this.address,
    required this.street,
    required this.screenWidth,
    required this.screenHeight,
    required this.statusBarHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.only(
        top: statusBarHeight + 8,
        left: screenWidth * 0.04,
        right: screenWidth * 0.04,
        bottom: screenHeight * 0.012,
      ),
      color: AppColors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.alertRed),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      street,
                      style: GoogleFonts.nunito(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Text(
                  address,
                  style: GoogleFonts.nunito(
                    fontSize: screenWidth * 0.030,
                    color: AppColors.darkGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/logo_cb_black.png",
            height: screenWidth * 0.10,
            width: screenWidth * 0.18,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
