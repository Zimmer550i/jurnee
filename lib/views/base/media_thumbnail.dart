import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as p;

class MediaThumbnail extends StatefulWidget {
  final String? path; // can be local file path or network URL

  const MediaThumbnail({super.key, required this.path});

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  File? _thumbnailFile;
  bool _loading = true;
  bool _isVideo = false;
  bool _isNetwork = false;

  @override
  void initState() {
    super.initState();
    if (widget.path != null) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    final path = widget.path;
    _isNetwork = path!.startsWith('http://') || path.startsWith('https://');

    String ext = p.extension(path).toLowerCase();

    // Detect video vs image
    if (['.mp4', '.mov', '.mkv', '.avi', '.webm'].contains(ext)) {
      _isVideo = true;
    } else if (['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(ext)) {
      _isVideo = false;
    } else {
      // Try to detect from URL if no extension
      if (_isNetwork) {
        if (path.contains('.mp4') || path.contains('.mov')) _isVideo = true;
      }
    }

    // Image → done
    if (!_isVideo) {
      setState(() {
        _loading = false;
      });
      return;
    }

    // Video → generate thumbnail
    try {
      final thumbPath = await VideoThumbnail.thumbnailFile(
        video: path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      setState(() {
        _thumbnailFile = thumbPath != null ? File(thumbPath) : null;
        _loading = false;
      });
    } catch (e) {
      _thumbnailFile = null;
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.path == null) {
      return Container(
        color: AppColors.gray.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: AppColors.gray.shade200),
              Text(
                "No Cover Image",
                textAlign: TextAlign.center,
                style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
              ),
            ],
          ),
        ),
      );
    }
    if (_loading) return const CustomLoading();

    if (!_isVideo) {
      if (_isNetwork) {
        return CustomNetworkedImage(
          url: widget.path,
          fit: BoxFit.cover,
          radius: 0,
        );
      } else {
        return Image.file(File(widget.path!), fit: BoxFit.cover);
      }
    }

    // Video thumbnail
    if (_thumbnailFile != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(_thumbnailFile!, fit: BoxFit.cover),
          const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
          ),
        ],
      );
    }

    return const Center(child: Text("Could not load thumbnail"));
  }
}
