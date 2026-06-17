import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkedImage extends StatelessWidget {
  final String? url;
  final File? file;
  final String? randomSeed;
  final double? height;
  final double? width;
  final double radius;
  final bool shimmer;
  final BoxFit? fit;
  final Color? placeholderColor;

  const CustomNetworkedImage({
    super.key,
    this.url,
    this.randomSeed,
    this.height,
    this.width,
    this.radius = 10,
    this.fit = BoxFit.cover,
    this.shimmer = true,
    this.file,
    this.placeholderColor,
  });

  bool get _hasValidUrl => url != null && url!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: file != null
          ? Image.file(file!, height: height, width: width, fit: fit)
          : !_hasValidUrl
          ? _buildPlaceholder()
          : CachedNetworkImage(
              imageUrl: url!,
              height: height,
              width: width,
              fit: fit,
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 150),
              memCacheHeight: height != null && height!.isFinite
                  ? height!.toInt()
                  : null,
              memCacheWidth: width != null && width!.isFinite
                  ? width!.toInt()
                  : null,
              errorWidget: (context, url, error) => _buildErrorWidget(),
              placeholder: shimmer
                  ? (context, url) => _buildShimmer()
                  : (context, url) => _buildPlaceholder(),
            ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: placeholderColor ?? AppColors.gray.shade200,
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.gray.shade400,
          size: _iconSize,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      color: AppColors.gray.shade200,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.gray.shade400,
          size: _iconSize,
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.gray.shade300,
      highlightColor: AppColors.gray[25]!,
      period: const Duration(milliseconds: 800),
      child: Container(
        height: height ?? width,
        width: width ?? height,
        color: Colors.white,
      ),
    );
  }

  double get _iconSize {
    final smallest = (height != null && width != null)
        ? (height! < width! ? height! : width!)
        : (height ?? width ?? 48);
    return (smallest * 0.35).clamp(16, 48);
  }
}
