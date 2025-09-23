import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<bool> values = List.generate(9, (_) {
    return false;
  });
  int expanded = -1;
  DateTime? start;
  DateTime? end;
  double? distance;
  String? placeId;

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
                tab("Live Now", 0),
                tab("Today", 1),
                tab("4+", 2, leading: "assets/icons/star.svg"),
                tab("\$", 3),
                tab("\$\$", 4),
                tab("\$\$\$", 5),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.gray.shade200,
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                dropDown("City", 0, placeId != null),
                dropDown("Dates", 1, start != null && end != null),
                dropDown("Distance", 2, distance != null),
              ],
            ),
          ),
          if (expanded == 0)
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
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
                              hintText: "Search cities...",
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
                    height: 32,
                    child: Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/location.svg"),
                        Text(
                          "Use My Location",
                          style: AppTexts.txsr.copyWith(
                            color: AppColors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < 50; i++)
                            SizedBox(
                              height: 32,
                              width: double.infinity,
                              child: Text(
                                "Sample city name",
                                style: AppTexts.tsmr.copyWith(
                                  color: AppColors.gray.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (expanded == 1)
            SfDateRangePicker(
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
              ),
              todayHighlightColor: AppColors.green.shade600,
              backgroundColor: AppColors.white,
              selectionColor: AppColors.green[50],
              rangeSelectionColor: AppColors.green[50],
              endRangeSelectionColor: AppColors.green.shade600,
              startRangeSelectionColor: AppColors.green.shade600,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  if (args.value is PickerDateRange) {
                    final PickerDateRange range = args.value;
                    start = range.startDate;
                    end = range.endDate;
                  }
                });
              },
              initialSelectedRange: PickerDateRange(start, end),
            ),
          if (expanded == 2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: 0.3,
                  activeColor: AppColors.green,
                  thumbColor: Colors.white,
                  padding: EdgeInsets.zero,
                  onChanged: (val) {},
                ),
                Text(
                  "10 miles",
                  style: AppTexts.txsr.copyWith(color: AppColors.gray),
                ),
              ],
            ),
          Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < values.length; i++) {
                        values[i] = false;
                      }
                    });
                  },
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

  Widget tab(String title, int pos, {String? leading, bool? dropDown}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          values[pos] = !values[pos];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: values[pos] ? AppColors.green.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray.shade300),
        ),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) CustomSvg(asset: leading),
            Text(
              title,
              style: AppTexts.tsmr.copyWith(
                color: values[pos] ? AppColors.white : AppColors.gray.shade700,
              ),
            ),
            if (dropDown == true)
              CustomSvg(
                asset: "assets/icons/dropdown.svg",
                color: values[pos] ? AppColors.white : AppColors.gray.shade700,
              ),
          ],
        ),
      ),
    );
  }

  Widget dropDown(String title, int index, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (expanded != index) {
            expanded = index;
          } else {
            expanded = -1;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.green.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray.shade300),
        ),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTexts.tsmr.copyWith(
                color: isActive ? AppColors.white : AppColors.gray.shade700,
              ),
            ),
            AnimatedRotation(
              turns: index == expanded ? 0.5 : 0,
              duration: Duration(milliseconds: 300),
              child: CustomSvg(
                asset: "assets/icons/dropdown.svg",
                color: isActive ? AppColors.white : AppColors.gray.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
