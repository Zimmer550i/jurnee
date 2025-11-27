import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:jurnee/views/base/profile_picture.dart';

/// Default portrait controls.
class CustomFlickPortraitControls extends StatelessWidget {
  final bool hasBackButton;
  final PostModel postData;
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
                    begin: AlignmentGeometry.bottomCenter,
                    end: AlignmentGeometry.topCenter,
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
                      Text(
                        postData.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTexts.dxsm.copyWith(
                          color: AppColors.gray[25],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            Get.find<PostController>().getDistance(
                              postData.location.coordinates[0],
                              postData.location.coordinates[1],
                            ),
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.gray[25],
                            ),
                          ),
                          const SizedBox(width: 8),
                          for (int i = 0; i < 4; i++)
                            CustomSvg(asset: "assets/icons/star.svg"),
                          for (int i = 0; i < 1; i++)
                            CustomSvg(
                              asset: "assets/icons/star.svg",
                              color: Colors.white,
                            ),
                          const SizedBox(width: 4),
                          Text(
                            postData.averageRating.toString(),
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.gray[25],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ProfilePicture(
                            image: postData.author.image,
                            size: 52,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            postData.author.name,
                            style: AppTexts.txlm.copyWith(
                              color: AppColors.gray[25],
                            ),
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
