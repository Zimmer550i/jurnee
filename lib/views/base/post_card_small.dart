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
  final double witdth;
  const PostCardSmall({super.key, required this.post, this.witdth = 350});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => PostDetails(post)),
      child: Container(
        // height: 126,
        width: witdth,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 9.8,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkedImage(
              url: post.image,
              radius: 8,
              height: 102,
              width: 102,
            ),
            Expanded(
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      post.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray.shade700,
                      ),
                    ),
                  ),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTexts.tmds.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      CustomSvg(asset: "assets/icons/location.svg", size: 16),
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
                      if (post.averageRating != null)
                        CustomSvg(asset: "assets/icons/star.svg"),
                      if (post.averageRating != null)
                        Text(
                          (post.averageRating).toString(),
                          style: AppTexts.tsmm.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
