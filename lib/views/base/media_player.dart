import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/video_widget.dart';

class MediaPlayer extends StatefulWidget {
  final List<String?> mediaList;
  const MediaPlayer({super.key, this.mediaList = const []});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  int index = 0;
  double? start;
  double travel = 0;

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
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              start = null;
              double threshhold = MediaQuery.of(context).size.height / 4;
              if (travel > threshhold) {
                
              } else if (travel < -threshhold) {}
              setState(() {
                travel = 0;
              });
            },
            onVerticalDragStart: (details) {
              start = details.globalPosition.dy;
              travel = 0;
            },
            onVerticalDragUpdate: (details) {
              setState(() {
                travel = start! - details.globalPosition.dy;
              });
            },
            child: Stack(
              children: [
                Transform.translate(
                  offset: Offset(0, -travel),
                  child: Positioned.fill(
                    child: VideoWidget(widget.mediaList.elementAt(index)!),
                  ),
                ),
              ],
            ),
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
