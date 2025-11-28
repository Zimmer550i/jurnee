import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/screens/home/post_details.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PostDetails(post));
      },
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: "post_cover_${post.id}",
                child: CustomNetworkedImage(
                  height: 184,
                  width: double.infinity,
                  url: post.image,
                  fit: BoxFit.cover,
                  radius: 0,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 136, minHeight: 120),
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
                        post.title.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                            post.averageRating == null
                                ? "N/A"
                                : post.averageRating!.toString(),
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray.shade600,
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
      ),
    );
  }
}
