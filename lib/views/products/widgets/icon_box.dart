import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class IconBox extends StatelessWidget {
  const IconBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.extraLightestPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
    );
  }
}
