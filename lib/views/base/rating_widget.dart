import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';

class RatingWidget extends StatelessWidget {
  final num? averageRating;
  final bool isSmall;
  final bool showText;
  const RatingWidget({
    super.key,
    required this.averageRating,
    this.isSmall = true,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => Reviews(count: 25));
      },
      child: Row(
        children: [
          for (int i = 0; i < 5; i++)
            CustomSvg(asset: "assets/icons/star.svg", size: isSmall ? 16 : 24),
          const SizedBox(width: 4),
          if (showText)
            Text(
              averageRating == null ? "N/A" : averageRating.toString(),
              style: AppTexts.tlgm.copyWith(color: AppColors.gray.shade400),
            ),
          // const SizedBox(width: 12),
          // Text(
          //   "See All",
          //   style: AppTexts.tsmr.copyWith(
          //     color: AppColors.green.shade600,
          //   ),
          // ),
        ],
      ),
    );
  }
}
