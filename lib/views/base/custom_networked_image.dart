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
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(radius),
      child: file != null
          ? Image.file(file!, height: height, width: width, fit: fit)
          : CachedNetworkImage(
              imageUrl:
                  url ??
                  "https://picsum.photos/${randomSeed == null ? "" : "seed/$randomSeed/"}${(width ?? 400).toInt()}/${(height ?? 400).toInt()}",
              height: height,
              width: width,
              fit: fit,
              errorWidget: (context, url, error) {
                return Container(
                  height: height,
                  width: width,
                  color: Colors.grey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        Text(error.toString()),
                      ],
                    ),
                  ),
                );
              },
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: AppColors.green.shade300,
                  highlightColor: AppColors.green[25]!,
                  period: Duration(milliseconds: 800),
                  child: Container(
                    height: height ?? width,
                    width: width ?? height,
                    color: Colors.white,
                  ),
                );
              },
            ),
    );
  }
}
