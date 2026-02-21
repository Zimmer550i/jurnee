import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/models/reivew_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/media_thumbnail.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/rating_widget.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  const ReviewWidget({super.key, required this.review});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RatingWidget(
                averageRating: review.rating,
                isSmall: true,
                showText: false,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat("MMM dd, yyyy").format(review.createdAt),
                style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
              ),
            ],
          ),
          Text(
            review.content,
            style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade700),
          ),
          if (review.image?.isNotEmpty ?? false)
            CustomNetworkedImage(url: review.image, height: 200),
          if (review.video?.isNotEmpty ?? false)
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: SizedBox(
                height: 200,
                child: MediaThumbnail(path: review.video),
              ),
            ),
          Row(
            spacing: 8,
            children: [
              ProfilePicture(size: 32, image: review.user.image),
              Text(
                review.user.name,
                style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
