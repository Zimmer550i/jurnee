import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_flick_portrait_controls.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String? url;
  final VideoPlayerController? controller;
  final PostModel postData;
  const VideoWidget(
    this.url, {
    super.key,
    this.controller,
    required this.postData,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late FlickManager flickManager;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
              VideoPlayerController.networkUrl(Uri.parse(widget.url!))
          ..setLooping(true)
          ..setVolume(1);
    flickManager = FlickManager(videoPlayerController: _controller);
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickManager: flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.cover,
        playerLoadingFallback: Stack(
          children: [
            Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
                constraints: BoxConstraints(minHeight: 30, minWidth: 30),
              ),
            ),
            Positioned(
              top: 12,
              left: 20,
              child: FlickAutoHideChild(
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Color(0xff1b1b1b).withAlpha(128),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomSvg(asset: "assets/icons/back.svg"),
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
                            widget.postData.title,
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
                                  widget.postData.location.coordinates[0],
                                  widget.postData.location.coordinates[1],
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
                                widget.postData.averageRating.toString(),
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
                                image: widget.postData.author.image,
                                size: 52,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.postData.author.name,
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
                              FlickCurrentPosition(fontSize: 14),
                              Spacer(),
                              FlickTotalDuration(fontSize: 14),
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
        ),
        playerErrorFallback: Stack(
          children: [
            Center(child: Icon(Icons.error_outline)),
            Positioned(
              top: 12,
              left: 20,
              child: FlickAutoHideChild(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Color(0xff1b1b1b).withAlpha(128),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomSvg(asset: "assets/icons/back.svg"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        controls: CustomFlickPortraitControls(postData: widget.postData),
      ),
    );
  }
}
