import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/moment_model.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_flick_portrait_controls.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/rating_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String initialUrl;
  final VideoPlayerController? controller;
  final PostModel? postData;
  final MomentModel? moment;
  const VideoWidget({
    super.key,
    required this.initialUrl,
    this.controller,
    this.postData,
    this.moment,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late FlickManager flickManager;
  late VideoPlayerController _controller;
  MomentModel? get _currentMoment => widget.moment;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
              VideoPlayerController.networkUrl(Uri.parse(widget.initialUrl))
          ..setLooping(true)
          ..setVolume(1);
    flickManager = FlickManager(videoPlayerController: _controller);
    _controller.addListener(() {
      if (_controller.value.hasError) {
        setState(() {});
        debugPrint("VIDEO ERROR: ${_controller.value.errorDescription}");
      }
    });

    debugPrint(widget.initialUrl);
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
        playerLoadingFallback: playerOverlay(isLoading: true),
        playerErrorFallback: playerOverlay(isError: true),
        controls: CustomFlickPortraitControls(
          postData: widget.postData,
          moment: widget.moment,
        ),
      ),
    );
  }

  Stack playerOverlay({bool isLoading = false, bool isError = false}) {
    return Stack(
      children: [
        if (isError)
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 4,
                  children: [
                    Icon(Icons.error_outline),
                    Text(
                      "Error Occured!",
                      style: AppTexts.tmdm.copyWith(color: AppColors.gray[25]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    _controller.value.errorDescription ?? "",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppColors.white,
              constraints: BoxConstraints(minHeight: 30, minWidth: 30),
            ),
          ),
        Positioned(
          top: 12,
          left: 20,
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomSvg(asset: "assets/icons/back.svg", size: 32),
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
                      if (widget.postData != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.postData!.title,
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
                              widget.postData!.category
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  widget.postData!.category.substring(1),
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
                                    widget.postData!.location.coordinates[0],
                                    widget.postData!.location.coordinates[1],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTexts.tmdm.copyWith(
                                    color: AppColors.gray[25],
                                  ),
                                ),
                                if (widget.postData!.averageRating != null)
                                  RatingWidget(
                                    averageRating:
                                        widget.postData!.averageRating,
                                  ),
                                if (widget.postData!.averageRating != null)
                                  Text(
                                    widget.postData!.averageRating.toString(),
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
                                  image:
                                      _currentMoment?.userImage.isNotEmpty ==
                                          true
                                      ? _currentMoment!.userImage
                                      : widget.postData!.author.image,
                                  size: 36,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _currentMoment?.userName.isNotEmpty == true
                                      ? _currentMoment!.userName
                                      : widget.postData!.author.name,
                                  style: AppTexts.tmdm.copyWith(
                                    color: AppColors.gray[25],
                                  ),
                                ),
                                Spacer(),
                                if (_currentMoment == null) ...[
                                  CustomSvg(
                                    size: 16,
                                    asset: "assets/icons/view.svg",
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.postData!.views.toString(),
                                    style: AppTexts.tsms.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: _currentMoment == null
                                      ? () {
                                          Get.find<PostController>()
                                              .likeToggle(
                                                widget.postData!.id,
                                                "post",
                                              )
                                              .then((message) {});
                                        }
                                      : null,
                                  child: Row(
                                    children: [
                                      CustomSvg(
                                        size: 16,
                                        asset: _currentMoment == null
                                            ? "assets/icons/${widget.postData!.isSaved ? "loved" : "love"}.svg"
                                            : "assets/icons/love.svg",
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _currentMoment == null
                                            ? widget.postData!.likes.toString()
                                            : _currentMoment!.like.toString(),
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
                                        "https://jurnee.app/post/${widget.postData!.id}";

                                    SharePlus.instance.share(
                                      ShareParams(
                                        text:
                                            "Check out ${widget.postData!.title} on Jurnee:\n$deepLink",
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
    );
  }
}
