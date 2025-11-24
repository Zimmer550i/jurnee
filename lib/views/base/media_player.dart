import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/video_widget.dart';

class MediaPlayer extends StatefulWidget {
  final List<String?> mediaList;
  const MediaPlayer({super.key, this.mediaList = const []});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  @override
  void initState() {
    super.initState();
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
            itemCount: widget.mediaList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  if (isVideo(widget.mediaList.elementAt(index)!))
                    Positioned.fill(
                      child: VideoWidget(widget.mediaList.elementAt(index)!),
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
                        Positioned.fill(
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
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 20,
                              ),
                              child: SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Post from event",
                                      style: AppTexts.tmdr.copyWith(
                                        color: AppColors.gray[25],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Event Name",
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
                                          "0.8 mi",
                                          style: AppTexts.tmdm.copyWith(
                                            color: AppColors.gray[25],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        for (int i = 0; i < 4; i++)
                                          CustomSvg(
                                            asset: "assets/icons/star.svg",
                                          ),
                                        for (int i = 0; i < 1; i++)
                                          CustomSvg(
                                            asset: "assets/icons/star.svg",
                                            color: Colors.white,
                                          ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "4.7",
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
                                          image:
                                              "https://thispersondoesnotexist.com",
                                          size: 52,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Sample Name",
                                          style: AppTexts.txlm.copyWith(
                                            color: AppColors.gray[25],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
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
