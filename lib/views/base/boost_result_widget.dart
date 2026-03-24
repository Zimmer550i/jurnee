import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/screens/post/post_details/post_details.dart';

/// Gold tone for active boost status (matches design accent).
const Color _boostStatusGold = Color(0xFFC9A227);

class BoostResultItem {
  final PostModel post;
  final int hoursRemaining;

  const BoostResultItem({
    required this.post,
    required this.hoursRemaining,
  });
}

class BoostResultWidget extends StatelessWidget {
  final PostModel post;
  final int hoursRemaining;

  const BoostResultWidget({
    super.key,
    required this.post,
    required this.hoursRemaining,
  });

  String get _displayDate {
    final d = post.startDate ?? post.createdAt;
    return DateFormat("MMMM d, y").format(d);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => PostDetails(post)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 9.8,
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkedImage(
                  url: post.image,
                  radius: 8,
                  height: 96,
                  width: 96,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTexts.tmds.copyWith(
                          color: AppColors.gray.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          CustomSvg(
                            asset: "assets/icons/calendar.svg",
                            size: 16,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _displayDate,
                              style: AppTexts.tsmr.copyWith(
                                color: AppColors.gray.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${post.views} views",
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.gray.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Boost active for $hoursRemaining hrs",
                style: AppTexts.tsmr.copyWith(
                  color: _boostStatusGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
