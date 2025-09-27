import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 4,
            children: [
              for (int i = 0; i < 5; i++)
                CustomSvg(asset: "assets/icons/star.svg", size: 24),
            ],
          ),
          Text(
            "Amazing experience! The DJ kept the energy high all night long. We had a blast, and the venue was perfect for our group size. Highly recommend!",
            style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade700),
          ),
          Row(
            spacing: 8,
            children: [
              ProfilePicture(
                size: 32,
                image: "https://thispersondoesnotexist.com",
              ),
              Text(
                "Sample Name",
                style: AppTexts.tsmb.copyWith(color: AppColors.gray.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
