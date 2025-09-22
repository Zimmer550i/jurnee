import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_icons.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasLeading;
  final String? trailing;
  const CustomAppBar({
    super.key,
    required this.title,
    this.hasLeading = true,
    this.trailing,
  });

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBG,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: SizedBox(
        height: 50,
        child: Row(
          children: [
            SizedBox(width: 12),
            InkWell(
              onTap: () => hasLeading ? Get.back() : null,
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 32,
                width: 32,
                child: hasLeading
                    ? Center(child: CustomSvg(asset: AppIcons.back))
                    : const SizedBox(),
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade700),
              ),
            ),
            trailing != null
                ? CustomSvg(asset: trailing!)
                : SizedBox(width: 32),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
