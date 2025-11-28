import 'package:flutter/material.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/post_card_small.dart';

class BoostPost extends StatelessWidget {
  final PostModel post;
  const BoostPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Boost Post"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "Boost Your Post",
                style: AppTexts.dsms.copyWith(color: AppColors.gray.shade700),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Boost keeps your post on top of the feed for 24 hours. Flat fee: \$5.",
                  style: AppTexts.tlgm.copyWith(color: AppColors.gray.shade400),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSvg(asset: "assets/icons/tick.svg"),
                      const SizedBox(width: 4),
                      Text(
                        "Post must have at least 1 clear photo",
                        style: AppTexts.tlgm.copyWith(
                          color: AppColors.gray.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSvg(asset: "assets/icons/tick.svg"),
                      const SizedBox(width: 4),
                      Text(
                        "Complete title & description",
                        style: AppTexts.tlgm.copyWith(
                          color: AppColors.gray.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSvg(asset: "assets/icons/tick.svg"),
                      const SizedBox(width: 4),
                      Text(
                        "Local relevance (within 25 miles)",
                        style: AppTexts.tlgm.copyWith(
                          color: AppColors.gray.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PostCardSmall(post: post),
              Spacer(),
              CustomButton(text: "Boost Now- \$5"),
              const SizedBox(height: 16),
              Text(
                "Posts will be rotated with a \"Featured\" badge in feed.",
                style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
