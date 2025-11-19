import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';

class CustomListHandler extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final double scrollThreshold;
  final double horizontalPadding;
  final Widget child;
  const CustomListHandler({
    super.key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.scrollThreshold = 200,
    this.horizontalPadding = 24,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - scrollThreshold) {
          if (onLoadMore != null) {
            onLoadMore!();
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        color: AppColors.green,
        backgroundColor: AppColors.green[25],
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}
