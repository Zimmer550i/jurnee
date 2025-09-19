import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int index;
  final Function(int)? onChanged;
  final void Function() onShowOverlay;
  final bool showOverlay;
  const CustomBottomNavbar({
    super.key,
    required this.index,
    this.onChanged,
    required this.onShowOverlay,
    required this.showOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -4),
            blurRadius: 18,
            color: Colors.black.withValues(alpha: 0.2),
          ),
        ],
      ),
      child: Row(
        children: [
          item("Home", "assets/icons/home.svg", 0),
          item("Messages", "assets/icons/chat.svg", 1),
          Expanded(
            child: SafeArea(
              child: GestureDetector(
                onTap: onShowOverlay,
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.green.shade700,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedRotation(
                      duration: Duration(milliseconds: 100),
                      turns: showOverlay ? -0.125 : 0,
                      child: CustomSvg(asset: "assets/icons/plus.svg"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          item("Notifications", "assets/icons/bell.svg", 2),
          item("Profile", "assets/icons/user.svg", 3),
        ],
      ),
    );
  }

  Widget item(String name, String icon, int pos) {
    bool isSelected = pos == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) onChanged!(pos);
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (isSelected)
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.green.shade700,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                    ),
                  )
                : SizedBox(width: 48, height: 18),
            CustomSvg(
              asset: icon,
              size: 32,
              color: isSelected
                  ? AppColors.green.shade700
                  : AppColors.gray.shade300,
            ),
            SafeArea(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  style: AppTexts.txsr.copyWith(
                    color: isSelected
                        ? AppColors.green.shade700
                        : AppColors.gray.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
