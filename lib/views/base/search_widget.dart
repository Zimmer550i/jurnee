import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        spacing: 20,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.white,
            surfaceTintColor: Colors.transparent,
            titleSpacing: 0,
            title: Row(
              children: [
                CustomSvg(asset: "assets/icons/logo.svg"),
                Spacer(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.gray.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              spacing: 16,
              children: [
                CustomSvg(asset: "assets/icons/search.svg"),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      isCollapsed: true,
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Search nearby...",
                      hintStyle: AppTexts.tsmr.copyWith(
                        color: AppColors.gray.shade400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              alignment: WrapAlignment.start,
              children: [
                tab("City", false),
                tab("Dates", false),
                tab("Distance", false),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              alignment: WrapAlignment.start,
              children: [
                tab("Live Now", false),
                tab("Live Now", false),
                tab("Live Now", false),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: CustomButton(
                  text: "Reset",
                  isSecondary: true,
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: CustomButton(text: "Apply", height: 44)),
              const SizedBox(width: 24),
            ],
          ),
          SizedBox(),
        ],
      ),
    );
  }

  Widget tab(String title, bool isSelected, {String? leading, bool? dropDown}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
          ),
        ],
      ),
    );
  }
}
