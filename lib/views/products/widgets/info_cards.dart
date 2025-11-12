import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'card_container.dart';
// import 'icon_box.dart';

class InfoCards extends StatelessWidget {
  final double screenWidth;
  const InfoCards({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CardContainer(
          child: Row(
            children: [
              Image(
                image: AssetImage("assets/images/fassilogo.png"),
                height: 32,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FSSAI Certified",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Lic. No: 12345678901234",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.verified, color: AppColors.confirmGreen, size: 20),
            ],
          ),
        ),
        // SizedBox(height: 12),
        // CardContainer(
        //   child: Row(
        //     children: [
        //       IconBox(),
        //       SizedBox(width: 12),
        //       Expanded(
        //         child: Text(
        //           "123 Marine Street, Coastal City, India",
        //           style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
