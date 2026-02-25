import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/screens/post/post_details.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PostDetails(post));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 9.8,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.vertical(
                top: Radius.circular(16),
              ),
              child: CustomNetworkedImage(
                height: 184,
                width: double.infinity,
                url: post.image,
                fit: BoxFit.cover,
                radius: 0,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 184, minHeight: 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  spacing: 6,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTexts.tlgs.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),

                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(
                          asset: "assets/icons/location.svg",
                          size: 16,
                          color: AppColors.green.shade700,
                        ),
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
                          CustomSvg(
                            asset: "assets/icons/star.svg",
                            size: 16,
                            color: AppColors.green.shade700,
                          ),
                        if (post.averageRating != null)
                          Text(
                            post.averageRating!.toString(),
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),

                        const SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gray[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            spacing: 4,
                            children: [
                              CustomSvg(
                                asset:
                                    "assets/icons/${post.category.toLowerCase()}.svg",
                                size: 16,
                              ),
                              Text(
                                post.category.substring(0, 1).toUpperCase() +
                                    post.category.substring(1),
                                style: AppTexts.txsm.copyWith(
                                  color: AppColors.gray.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Text(
                      post.description.toString(),
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
