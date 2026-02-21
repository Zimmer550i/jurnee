import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/custom_loading.dart';

class CustomListHandler extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final double scrollThreshold;
  final double horizontalPadding;
  final Widget child;
  final bool reverse;
  final bool topPadding;
  final bool isLoading;
  final bool shrinkWrap;
  const CustomListHandler({
    super.key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.reverse = false,
    this.isLoading = false,
    this.topPadding = false,
    this.shrinkWrap = false,
    this.scrollThreshold = 200,
    this.horizontalPadding = 24,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (reverse) {
          if (scrollInfo.metrics.pixels <= scrollThreshold) {
            if (onLoadMore != null) onLoadMore!();
          }
        } else {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - scrollThreshold) {
            if (onLoadMore != null) onLoadMore!();
          }
        }

        return false;
      },
      child: isLoading
          ? Center(child: CustomLoading())
          : reverse
          ? SingleChildScrollView(
              clipBehavior: Clip.none,
              reverse: reverse,
              physics: shrinkWrap
                  ? NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SafeArea(child: child),
            )
          : RefreshIndicator(
              onRefresh: onRefresh ?? () async {},
              color: AppColors.green,
              backgroundColor: AppColors.green[25],
              child: SingleChildScrollView(
                reverse: reverse,
                physics: shrinkWrap
                    ? NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SafeArea(top: topPadding, child: child),
              ),
            ),
    );
  }
}
