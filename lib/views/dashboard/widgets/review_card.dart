import 'package:flutter/material.dart';

import '../../../Constants/app_colors.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: w * 0.7,
      margin: EdgeInsets.only(right: w * 0.04),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset("assets/images/bgImages/reviewWhatermark.jpg",
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            padding: EdgeInsets.all(w * 0.04),         
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review["name"],
                        style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black)),
                    Row(
                      children: List.generate(
                        5,
                            (i) => Icon(Icons.star,
                            size: w * 0.045,
                            color: i < review["rating"]
                                ? Colors.amber
                                : Colors.grey.shade300),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.01),
                Expanded(
                  child: Text(
                    review["comment"],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: w * 0.035, color: AppColors.darkGrey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
