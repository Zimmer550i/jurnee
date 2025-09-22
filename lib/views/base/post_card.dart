import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.white),
        child: Column(
          children: [
            SizedBox(
              height: 184,
              width: double.infinity,
              child: Image.asset(
                "assets/images/sample_image.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 124,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cozy Coffee Spot",
                      style: AppTexts.dxss.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),

                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/location.svg"),
                        Text(
                          "2.3 miles",
                          style: AppTexts.tsmm.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                        Container(),
                        CustomSvg(asset: "assets/icons/star.svg"),
                        Text(
                          "4.9",
                          style: AppTexts.tsmm.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      "Shop our summer collection of dresses, now 50% off. Free delivery within 10 miles and 24/7 customer service...",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
