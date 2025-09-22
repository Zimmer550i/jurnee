import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          for (int i = 0; i < 16; i++) notificationWidget(i > 2),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget notificationWidget(bool isRead) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isRead ? null : AppColors.green.shade100,
      ),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: isRead ? AppColors.green[50] : AppColors.green[25],
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
              spacing: 4,
              children: [
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.",
                  style: AppTexts.tsmm.copyWith(color: AppColors.gray.shade700),
                ),
                Row(
                  children: [
                    CustomSvg(asset: "assets/icons/clock.svg"),
                    const SizedBox(width: 4),
                    Text(
                      "5 minutes ago",
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
    );
  }
}
