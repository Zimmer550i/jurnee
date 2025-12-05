import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/models/schedule_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/home/post_location.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ServiceBooking extends StatefulWidget {
  final PostModel post;
  const ServiceBooking({super.key, required this.post});

  @override
  State<ServiceBooking> createState() => _ServiceBookingState();
}

class _ServiceBookingState extends State<ServiceBooking> {
  DateTime? date;
  // Map<String, TimeSlot> selected = {};
  List<String> selected = [];

  void _onDateSelected(DateTime? val) {
    setState(() {
      date = val;
    });
  }
  // TODO: Add Logic for Booking

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Service-Booking"),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      widget.post.title,
                      style: AppTexts.dxss.copyWith(
                        color: AppColors.gray.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ProfilePicture(
                          image: widget.post.author.image,
                          size: 52,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.post.author.name,
                          style: AppTexts.txlm.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SfDateRangePicker(
                      headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: AppColors.gray[50],
                        textStyle: AppTexts.txls.copyWith(
                          color: AppColors.gray.shade700,
                        ),
                      ),
                      todayHighlightColor: AppColors.green.shade600,
                      backgroundColor: AppColors.gray[50],
                      selectionColor: AppColors.green.shade600,
                      selectionMode: DateRangePickerSelectionMode.single,
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                            if (args.value is DateTime) {
                              _onDateSelected(args.value);
                            }
                          },
                    ),
                    // const SizedBox(height: 24),
                    if (date != null)
                      Text(
                        DateFormat("EEEE, MMMM d").format(date!),
                        style: AppTexts.txls.copyWith(
                          color: AppColors.gray.shade700,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        for (var i in getSlots())
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selected.contains(i.id)) {
                                  selected.remove(i.id);
                                } else {
                                  selected.add(i.id!);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: selected.contains(i.id)
                                    ? AppColors.green.shade100
                                    : null,
                                border: Border.all(
                                  color: selected.contains(i.id)
                                      ? AppColors.green.shade600
                                      : AppColors.gray.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                Formatter.timeFormatter(
                                  time: TimeOfDay(
                                    hour:
                                        int.tryParse(
                                          i.start!.split(":").first,
                                        ) ??
                                        0,
                                    minute:
                                        int.tryParse(
                                          i.start!.split(":").last,
                                        ) ??
                                        0,
                                  ),
                                ),
                                style: AppTexts.tsms.copyWith(
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Start From",
                          style: AppTexts.tmdr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "\$${widget.post.price?.toInt() ?? 0}",
                          style: AppTexts.dxss.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => PostLocation(post: widget.post));
                      },
                      child: Row(
                        spacing: 4,
                        children: [
                          CustomSvg(
                            asset: "assets/icons/location.svg",
                            size: 24,
                          ),
                          Expanded(
                            child: Text(
                              widget.post.address.toString(),
                              style: AppTexts.tmdm.copyWith(
                                color: AppColors.gray.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 12,
            child: SafeArea(child: CustomButton(text: "Continue")),
          ),
        ],
      ),
    );
  }

  List<TimeSlot> getSlots() {
    if (date == null) return [];
    try {
      final weeks = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
      final schedule = widget.post.schedule.firstWhere(
        (val) => val.day == weeks[date!.weekday - 1],
      );

      return schedule.timeSlots;
    } catch (_) {
      return [];
    }
  }
}
