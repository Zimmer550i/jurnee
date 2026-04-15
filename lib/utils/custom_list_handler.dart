import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/custom_loading.dart';

class CustomListHandler extends StatefulWidget {
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
  State<CustomListHandler> createState() => _CustomListHandlerState();
}

class _CustomListHandlerState extends State<CustomListHandler> {
  bool _isLoadMoreInProgress = false;
  bool _canTriggerLoadMore = true;

  Future<void> _handleLoadMore(ScrollNotification scrollInfo) async {
    final onLoadMore = widget.onLoadMore;
    if (onLoadMore == null) return;

    final shouldLoadMore = widget.reverse
        ? scrollInfo.metrics.pixels <= widget.scrollThreshold
        : scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - widget.scrollThreshold;

    if (!shouldLoadMore) {
      _canTriggerLoadMore = true;
      return;
    }

    if (!_canTriggerLoadMore || _isLoadMoreInProgress) return;

    _canTriggerLoadMore = false;
    _isLoadMoreInProgress = true;
    try {
      await onLoadMore();
    } finally {
      _isLoadMoreInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        _handleLoadMore(scrollInfo);

        return false;
      },
      child: widget.isLoading
          ? Center(child: CustomLoading())
          : widget.reverse
          ? SingleChildScrollView(
              clipBehavior: Clip.none,
              reverse: widget.reverse,
              physics: widget.shrinkWrap
                  ? NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
              ),
              child: SafeArea(child: widget.child),
            )
          : RefreshIndicator(
              onRefresh: widget.onRefresh ?? () async {},
              color: AppColors.green,
              backgroundColor: AppColors.green[25],
              child: SingleChildScrollView(
                reverse: widget.reverse,
                physics: widget.shrinkWrap
                    ? NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding,
                ),
                child: SafeArea(top: widget.topPadding, child: widget.child),
              ),
            ),
    );
  }
}
