import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/maps_controller.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/home/home.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  const SearchWidget(this.controller, {super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final post = Get.find<PostController>();
  final mapCtrl = Get.put(MapsController());

  final searchCtrl = TextEditingController();
  final placeCtrl = TextEditingController();
  final minPriceCtrl = TextEditingController();
  final maxPriceCtrl = TextEditingController();

  bool showPrice = false;
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
                    autofocus: true,
                    onChanged: (value) => post.search.value = value,
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
            child: Obx(
              () => Wrap(
                runSpacing: 8,
                spacing: 8,
                alignment: WrapAlignment.start,
                children: [
                  tab("4+", post.highlyRated.value, (val) {
                    post.highlyRated.value = val;
                  }, leading: "assets/icons/star.svg"),
                  tab(
                    "Events",
                    post.categoryList.contains("event"),
                    (val) {
                      if (post.categoryList.contains("event")) {
                        post.categoryList.remove('event');
                      } else {
                        post.categoryList.add('event');
                      }
                    },
                    leading: "assets/icons/event.svg",
                  ),
                  tab(
                    "Deals",
                    post.categoryList.contains("deal"),
                    (val) {
                      if (post.categoryList.contains("deal")) {
                        post.categoryList.remove('deal');
                      } else {
                        post.categoryList.add('deal');
                      }
                    },
                    leading: "assets/icons/deal.svg",
                  ),
                  tab(
                    "Services",
                    post.categoryList.contains("service"),
                    (val) {
                      if (post.categoryList.contains("service")) {
                        post.categoryList.remove('service');
                      } else {
                        post.categoryList.add('service');
                      }
                    },
                    leading: "assets/icons/service.svg",
                  ),
                  tab(
                    "Alerts",
                    post.categoryList.contains("alert"),
                    (val) {
                      if (post.categoryList.contains("alert")) {
                        post.categoryList.remove('alert');
                      } else {
                        post.categoryList.add('alert');
                      }
                    },
                    leading: "assets/icons/alert.svg",
                  ),
                  tab("Price", showPrice, (val) {
                    setState(() {
                      showPrice = val;
                    });
                  }, leading: "assets/icons/price.svg"),
                ],
              ),
            ),
          ),
          if (showPrice)
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    title: "Min Price",
                    controller: minPriceCtrl,
                    hintText: "Enter minimum price",
                    textInputType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    title: "Max Price",
                    controller: maxPriceCtrl,
                    hintText: "Enter maximum price",
                    textInputType: TextInputType.number,
                  ),
                ),
              ],
            ),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.gray.shade200,
          ),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => Wrap(
                runSpacing: 8,
                spacing: 8,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  dropDown("City", 0, post.customLocation.value != null),
                  dropDown("Dates", 1, start != null),
                  dropDown("Distance", 2, post.distance.value != null),
                ],
              ),
            ),
          ),
          if (expanded == 0)
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => Column(
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
                              controller: placeCtrl,
                              onChanged: (value) =>
                                  mapCtrl.onSearchChanged(value),
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
                    if (mapCtrl.predictions.isEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            placeCtrl.text = "My Location";
                            expanded = -1;
                            try {
                              post.customLocation.value = LatLng(
                                post.userLocation.value!.latitude,
                                post.userLocation.value!.longitude,
                              );
                            } catch (_) {
                              customSnackBar("Couldn't fetch user location");
                            }
                          });
                        },
                        child: SizedBox(
                          height: 32,
                          child: Row(
                            spacing: 8,
                            children: [
                              CustomSvg(
                                asset: "assets/icons/location.svg",
                                size: 18,
                              ),
                              Text(
                                "Use My Location",
                                style: AppTexts.tsmm.copyWith(
                                  color: AppColors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    for (var i in mapCtrl.predictions)
                      GestureDetector(
                        onTap: () {
                          mapCtrl.selectPrediction(i, placeCtrl);
                          setState(() {
                            expanded = -1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            i.description,
                            maxLines: 2,
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: post.distance.value ?? 0.05,
                    activeColor: AppColors.green,
                    thumbColor: Colors.white,
                    padding: EdgeInsets.zero,
                    onChanged: (val) {
                      post.distance.value = val;
                    },
                  ),
                  Text(
                    "${post.distance.value == null ? "50" : (post.distance.value! * 1000).toInt()} miles",
                    style: AppTexts.txsr.copyWith(color: AppColors.gray),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    post.customLocation.value = null;
                    post.date.value = null;
                    post.distance.value = null;
                    post.maxPrice.value = null;
                    post.minPrice.value = null;
                    post.search.value = null;
                    post.highlyRated.value = false;
                    post.categoryList.clear();
                    homeKey.currentState?.setState(() {
                      homeKey.currentState?.searchEnabled = false;
                    });
                    post.fetchPosts().then((message) {
                      if (message != "success") {
                        customSnackBar(message);
                      }
                    });
                  },
                  text: "Reset",
                  isSecondary: true,
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    homeKey.currentState?.setState(() {
                      homeKey.currentState!.searchEnabled = false;
                      homeKey.currentState!.tab = 0;
                    });
                    post.fetchPosts().then((message) {
                      if (message != "success") {
                        customSnackBar(message);
                      }
                    });
                  },
                  text: "Apply",
                  height: 44,
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          SizedBox(),
        ],
      ),
    );
  }

  Widget tab(
    String title,
    bool isSelected,
    Function(bool) onTap, {
    String? leading,
    bool? dropDown,
  }) {
    return GestureDetector(
      onTap: () => onTap(!isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray.shade300),
        ),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null)
              CustomSvg(
                asset: leading,
                height: 16,
                color: isSelected
                    ? AppColors.green[25]
                    : AppColors.green.shade600,
              ),
            Text(
              title,
              style: AppTexts.tsmr.copyWith(
                color: isSelected ? AppColors.white : AppColors.gray.shade700,
              ),
            ),
            if (dropDown == true)
              CustomSvg(
                asset: "assets/icons/dropdown.svg",
                color: isSelected ? AppColors.white : AppColors.gray.shade700,
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
