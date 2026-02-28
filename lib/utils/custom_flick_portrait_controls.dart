import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/rating_widget.dart';
import 'package:share_plus/share_plus.dart';

/// Default portrait controls.
class CustomFlickPortraitControls extends StatelessWidget {
  final bool hasBackButton;
  final PostModel? postData;
  const CustomFlickPortraitControls({
    super.key,
    this.iconSize = 20,
    this.fontSize = 12,
    this.progressBarSettings,
    this.hasBackButton = true,
    required this.postData,
  });

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: FlickPlayToggle(
                      size: 100,
                      color: AppColors.white,
                      padding: EdgeInsets.all(6),
                      // decoration: BoxDecoration(
                      //   color: Color(0xff1b1b1b).withAlpha(128),
                      //   borderRadius: BorderRadius.circular(40),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasBackButton)
          Positioned(
            top: 12,
            left: 22,
            child: FlickAutoHideChild(
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: CustomSvg(
                        asset: "assets/icons/back.svg",
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  // color: Color(0xff1b1b1b).withAlpha(128),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent],
                  ),
                ),
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   "Post from event",
                      //   style: AppTexts.tmdr.copyWith(
                      //     color: AppColors.gray[25],
                      //   ),
                      // ),
                      // const SizedBox(height: 12),
                      if (postData != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postData!.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray[25],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              postData!.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTexts.txsr.copyWith(
                                color: AppColors.gray[50],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  Get.find<PostController>().getDistance(
                                    postData!.location.coordinates[0],
                                    postData!.location.coordinates[1],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTexts.tmdm.copyWith(
                                    color: AppColors.gray[25],
                                  ),
                                ),
                                if (postData!.averageRating != null)
                                  RatingWidget(
                                    averageRating: postData!.averageRating,
                                  ),
                                if (postData!.averageRating != null)
                                  Text(
                                    postData!.averageRating.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTexts.tsmm.copyWith(
                                      color: AppColors.gray[25],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ProfilePicture(
                                  image: postData!.author.image,
                                  size: 36,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  postData!.author.name,
                                  style: AppTexts.tmdm.copyWith(
                                    color: AppColors.gray[25],
                                  ),
                                ),
                                Spacer(),
                                CustomSvg(
                                  size: 16,
                                  asset: "assets/icons/view.svg",
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  postData!.views.toString(),
                                  style: AppTexts.tsms.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    Get.find<PostController>()
                                        .likeToggle(postData!.id, "post")
                                        .then((message) {});
                                  },
                                  child: Row(
                                    children: [
                                      CustomSvg(
                                        size: 16,
                                        asset:
                                            "assets/icons/${postData!.isSaved ? "loved" : "love"}.svg",
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        postData!.likes.toString(),
                                        style: AppTexts.tsms.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    final deepLink =
                                        "https://jurnee.app/post/${postData!.id}";

                                    SharePlus.instance.share(
                                      ShareParams(
                                        text:
                                            "Check out ${postData!.title} on Jurnee:\n$deepLink",
                                        subject: "Jurnee Post",
                                      ),
                                    );
                                  },
                                  child: CustomSvg(
                                    size: 16,
                                    asset: "assets/icons/share.svg",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      FlickVideoProgressBar(
                        flickProgressBarSettings: FlickProgressBarSettings(
                          playedColor: AppColors.green,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlickCurrentPosition(fontSize: fontSize),
                          Spacer(),
                          FlickTotalDuration(fontSize: fontSize),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
