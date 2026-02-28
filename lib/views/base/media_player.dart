import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/rating_widget.dart';
import 'package:jurnee/views/base/video_widget.dart';
import 'package:share_plus/share_plus.dart';

class MediaPlayer extends StatefulWidget {
  final List<String?> mediaList;
  final PostModel postData;
  final String? preferedStart;
  const MediaPlayer({
    super.key,
    this.preferedStart,
    this.mediaList = const [],
    required this.postData,
  });

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    getIndex();
  }

  void getIndex() {
    for (index = 0; index < widget.mediaList.length; index++) {
      if (widget.preferedStart == widget.mediaList[index]) {
        return;
      }
    }
    if (index == widget.mediaList.length) {
      index == 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // or your AppColors.green[600]
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // iOS uses inverse
      ),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          bottom: false,
          top: false,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: PageController(initialPage: index),
            itemCount: widget.mediaList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  if (isVideo(widget.mediaList.elementAt(index)!))
                    Positioned.fill(
                      child: VideoWidget(
                        widget.mediaList.elementAt(index)!,
                        postData: widget.postData,
                      ),
                    ),

                  if (!isVideo(widget.mediaList.elementAt(index)!))
                    Stack(
                      children: [
                        Positioned.fill(
                          child: CustomNetworkedImage(
                            url: widget.mediaList.elementAt(index)!,
                            radius: 0,
                            fit: BoxFit.contain,
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
                                  child: CustomSvg(
                                    asset: "assets/icons/back.svg",
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
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
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 20,
                              ),
                              child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.postData.title,
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
                                      widget.postData.title,
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
                                          Get.find<PostController>()
                                              .getDistance(
                                                widget
                                                    .postData
                                                    .location
                                                    .coordinates[0],
                                                widget
                                                    .postData
                                                    .location
                                                    .coordinates[1],
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTexts.tmdm.copyWith(
                                            color: AppColors.gray[25],
                                          ),
                                        ),
                                        if (widget.postData.averageRating !=
                                            null)
                                          RatingWidget(
                                            averageRating:
                                                widget.postData.averageRating,
                                          ),
                                        if (widget.postData.averageRating !=
                                            null)
                                          Text(
                                            widget.postData.averageRating
                                                .toString(),
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
                                          image: widget.postData.author.image,
                                          size: 36,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          widget.postData.author.name,
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
                                          widget.postData.views.toString(),
                                          style: AppTexts.tsms.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            Get.find<PostController>()
                                                .likeToggle(
                                                  widget.postData.id,
                                                  "post",
                                                )
                                                .then((message) {});
                                          },
                                          child: Row(
                                            children: [
                                              CustomSvg(
                                                size: 16,
                                                asset:
                                                    "assets/icons/${widget.postData.isSaved ? "loved" : "love"}.svg",
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                widget.postData.likes
                                                    .toString(),
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
                                                "https://jurnee.app/post/${widget.postData.id}";

                                            SharePlus.instance.share(
                                              ShareParams(
                                                text:
                                                    "Check out ${widget.postData.title} on Jurnee:\n$deepLink",
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool isVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  bool isImage(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }
}
