import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/media_type.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaThumbnail extends StatefulWidget {
  final String? path; // can be local file path or network URL
  final bool showPlayButton;

  const MediaThumbnail({
    super.key,
    required this.path,
    this.showPlayButton = true,
  });

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
    _reloadForPath(widget.path);
  }

  @override
  void didUpdateWidget(covariant MediaThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      setState(() {
        _reloadForPath(widget.path);
      });
    }
  }

  void _reloadForPath(String? path) {
    _thumbnailFile = null;
    _isVideo = false;
    _isNetwork = false;
    _loading = path != null;

    if (path != null) {
      _loadThumbnail(path);
    }
  }

  Future<void> _loadThumbnail(String path) async {
    _isNetwork = path.startsWith('http://') || path.startsWith('https://');
    _isVideo = isVideoMedia(path: path);

    // Image → done
    if (!_isVideo) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      return;
    }

    // Video → generate thumbnail
    try {
      final thumbPath = await VideoThumbnail.thumbnailFile(
        video: path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      if (mounted) {
        setState(() {
          _thumbnailFile = thumbPath != null ? File(thumbPath) : null;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _thumbnailFile = null;
          _loading = false;
        });
      }
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
      return _buildVideoOverlay(
        Image.file(_thumbnailFile!, fit: BoxFit.cover),
      );
    }

    return _buildVideoOverlay(
      Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: Text(
          "Could not load thumbnail",
          style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildVideoOverlay(Widget child) {
    if (!widget.showPlayButton) return child;

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}
