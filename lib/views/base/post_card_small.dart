import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';

class PostCardSmall extends StatelessWidget {
  const PostCardSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.green, width: 0.5),
      ),
      child: Row(
        spacing: 20,
        children: [
          CustomNetworkedImage(radius: 10, height: 102, width: 102),
          Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cozy Coffee Spot",
                style: AppTexts.dxss.copyWith(color: AppColors.gray.shade600),
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
            ],
          ),
        ],
      ),
    );
  }
}
