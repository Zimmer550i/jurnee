import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/screens/post/post_details.dart';

class PostCardSmall extends StatelessWidget {
  final PostModel post;
  final double multiplier;
  const PostCardSmall({super.key, required this.post, this.multiplier = 1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => PostDetails(post)),
      child: Container(
        height: 126,
        width: 350,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.green, width: 0.5),
        ),
        child: Row(
          spacing: 20,
          children: [
            CustomNetworkedImage(
              url: post.image,
              radius: 10,
              height: 102,
              width: 102,
            ),
            Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: AppTexts.dxss.copyWith(
                    color: AppColors.gray.shade600,
                  ),
                ),
    
                Row(
                  spacing: 4,
                  children: [
                    CustomSvg(asset: "assets/icons/location.svg"),
                    Text(
                      Get.find<PostController>().getDistance(
                        post.location.coordinates[0],
                        post.location.coordinates[1],
                      ),
                      style: AppTexts.tsmm.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    Container(),
                    CustomSvg(asset: "assets/icons/star.svg"),
                    Text(
                      (post.averageRating ?? "N/A").toString(),
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
      ),
    );
  }
}
