import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/moment_model.dart';
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
  final PostModel postData;

  /// Matched against the playlist to pick the first page (full [PostController.mediaList] for posts).
  final String initialUrl;

  /// Standalone URLs (e.g. comment image). Ignores post moments; no [MomentModel] metadata.
  final List<String>? staticUrls;

  const MediaPlayer({
    super.key,
    required this.postData,
    required this.initialUrl,
    this.staticUrls,
  });

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  late final PageController _pageController;
  late int _initialIndex;

  bool get _usesStaticUrls =>
      widget.staticUrls != null && widget.staticUrls!.isNotEmpty;

  List<MomentModel> _resolveMoments() {
    if (_usesStaticUrls) return const [];
    return Get.find<PostController>().mediaList.toList();
  }

  List<String> _buildUrls(List<MomentModel> moments) {
    if (_usesStaticUrls) return List<String>.from(widget.staticUrls!);
    return moments.map((m) => m.url).toList();
  }

  MomentModel? _momentForUrl(String url, List<MomentModel> moments) {
    if (_usesStaticUrls) return null;
    for (final m in moments) {
      if (m.url == url) return m;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final moments = _resolveMoments();
    final urls = _buildUrls(moments);
    _initialIndex = 0;
    for (var i = 0; i < urls.length; i++) {
      if (urls[i] == widget.initialUrl) {
        _initialIndex = i;
        break;
      }
    }
    _pageController = PageController(initialPage: _initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moments = _resolveMoments();
    final urls = _buildUrls(moments);

    if (urls.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.black,
        body: Center(
          child: Text('No media', style: TextStyle(color: AppColors.gray[25])),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          bottom: false,
          top: false,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            // itemCount: urls.length,
            itemBuilder: (context, index) {
              final url = urls[index % urls.length];
              final moment = _momentForUrl(url, moments);
              return _MediaSlide(
                url: url,
                moment: moment,
                postData: widget.postData,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MediaSlide extends StatelessWidget {
  const _MediaSlide({
    required this.url,
    required this.moment,
    required this.postData,
  });

  final String url;
  final MomentModel? moment;
  final PostModel postData;

  bool _isVideo(String url) {
    const videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo(url)) {
      return VideoWidget(initialUrl: url, postData: postData, moment: moment);
    }
    return Stack(
      children: [
        Positioned.fill(
          child: CustomNetworkedImage(url: url, radius: 0, fit: BoxFit.contain),
        ),
        Positioned(
          top: 12,
          left: 20,
          child: SafeArea(
            child: GestureDetector(
              onTap: Get.back,
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
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postData.title,
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
                      postData.category.substring(0, 1).toUpperCase() +
                          postData.category.substring(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTexts.txsr.copyWith(color: AppColors.gray[50]),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          Get.find<PostController>().getDistance(
                            postData.location.coordinates[0],
                            postData.location.coordinates[1],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTexts.tmdm.copyWith(
                            color: AppColors.gray[25],
                          ),
                        ),
                        if (postData.averageRating != null)
                          RatingWidget(
                            showText: false,
                            averageRating: postData.averageRating,
                          ),
                        if (postData.averageRating != null)
                          Text(
                            postData.averageRating.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray[25],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (moment != null)
                      _MomentActionsRow(moment: moment!, postData: postData)
                    else
                      _PostActionsRow(postData: postData),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MomentActionsRow extends StatelessWidget {
  const _MomentActionsRow({required this.moment, required this.postData});

  final MomentModel moment;
  final PostModel postData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfilePicture(
          image: moment.userImage.isNotEmpty ? moment.userImage : null,
          size: 36,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            moment.userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTexts.tmdm.copyWith(color: AppColors.gray[25]),
          ),
        ),
        CustomSvg(
          size: 20,
          asset: "assets/icons/love.svg",
          color: Colors.white,
        ),
        const SizedBox(width: 4),
        Text(
          moment.like.toString(),
          style: AppTexts.tsms.copyWith(color: Colors.white),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            final deepLink = "https://jurnee.app/post/${postData.id}";
            SharePlus.instance.share(
              ShareParams(
                text: "Check out ${postData.title} on Jurnee:\n$deepLink",
                subject: "Jurnee Post",
              ),
            );
          },
          child: CustomSvg(
            size: 20,
            asset: "assets/icons/share.svg",
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _PostActionsRow extends StatelessWidget {
  const _PostActionsRow({required this.postData});

  final PostModel postData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfilePicture(image: postData.author.image, size: 36),
        const SizedBox(width: 8),
        Text(
          postData.author.name,
          style: AppTexts.tmdm.copyWith(color: AppColors.gray[25]),
        ),
        Spacer(),
        CustomSvg(
          size: 20,
          asset: "assets/icons/view.svg",
          color: Colors.white,
        ),
        const SizedBox(width: 4),
        Text(
          postData.views.toString(),
          style: AppTexts.tsms.copyWith(color: Colors.white),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Get.find<PostController>()
                .likeToggle(postData.id, "post")
                .then((_) {});
          },
          child: Row(
            children: [
              CustomSvg(
                size: 20,
                asset:
                    "assets/icons/${postData.isSaved ? "loved" : "love"}.svg",
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                postData.likes.toString(),
                style: AppTexts.tsms.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            final deepLink = "https://jurnee.app/post/${postData.id}";
            SharePlus.instance.share(
              ShareParams(
                text: "Check out ${postData.title} on Jurnee:\n$deepLink",
                subject: "Jurnee Post",
              ),
            );
          },
          child: CustomSvg(
            size: 20,
            asset: "assets/icons/share.svg",
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
