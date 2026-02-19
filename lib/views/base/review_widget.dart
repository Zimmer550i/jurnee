import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/rating_widget.dart';

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
            children: [
              RatingWidget(averageRating: 4.5, isSmall: true, showText: false),
              const SizedBox(width: 4),
              Text(
                DateFormat("MMM dd, yyyy").format(DateTime.now()),
                style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
              ),
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
                style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
