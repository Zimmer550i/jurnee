import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/notification_controller.dart';
import 'package:jurnee/models/notification_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/views/base/custom_loading.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBG,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 24),
            CustomSvg(asset: "assets/icons/logo.svg", height: 22),
            Spacer(),
            const SizedBox(width: 24),
          ],
        ),
      ),
      body: CustomListHandler(
        onRefresh: () => controller.fetchNotifications(),
        onLoadMore: () => controller.fetchNotifications(loadMore: true),
        horizontalPadding: 0,
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 20),
              for (var i in controller.notifications) notificationWidget(i),
              if (controller.isLoading.value) CustomLoading(),
              if (!controller.isMoreLoading.value &&
                  !controller.isFirstLoad.value &&
                  controller.notifications.isEmpty)
                Center(
                  child: Text(
                    "You have to notifications",
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.gray.shade300,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationWidget(NotificationModel item) {
    return GestureDetector(
      onTap: () {
        controller.readNotification(item.id);
      },
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: item.read ? null : AppColors.green.shade100,
        ),
        child: Row(
          children: [
            const SizedBox(width: 24),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: item.read ? AppColors.green[50] : AppColors.green[25],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomSvg(
                  asset: "assets/icons/bell.svg",
                  size: 28,
                  color: AppColors.green.shade700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    item.content,
                    style: AppTexts.tsmm.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  Row(
                    children: [
                      CustomSvg(asset: "assets/icons/clock.svg"),
                      const SizedBox(width: 4),
                      Text(
                        Formatter.durationFormatter(
                          DateTime.now().difference(item.createdAt),
                        ),
                        style: AppTexts.txsr.copyWith(
                          color: AppColors.gray.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
