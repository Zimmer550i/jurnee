import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/screens/messages/offer_preview.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => OfferPreview());
      },
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.white),
          child: Column(
            children: [
              CustomNetworkedImage(
                height: 184,
                width: double.infinity,
                url: "https://picsum.photos/300/300",
                fit: BoxFit.cover,
                radius: 0,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 184, minHeight: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "post.title.toString()",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTexts.tlgs.copyWith(
                          color: AppColors.gray.shade600,
                        ),
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
                            "4.5",
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          CustomSvg(asset: "assets/icons/offer.svg", size: 16),
                          Expanded(
                            child: Text(
                              DateFormat(
                                "dd MMM, yyyy - hh:mm aa",
                              ).format(DateTime.now()),
                              style: AppTexts.tsmr.copyWith(
                                color: AppColors.gray.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        "post.description.toString()" * 5,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.gray.shade600,
                        ),
                      ),

                      Text("Total: \$450", style: AppTexts.tlgb),
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
