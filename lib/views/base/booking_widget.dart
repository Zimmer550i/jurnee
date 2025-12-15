import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/models/booking_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class BookingWidget extends StatelessWidget {
  final BookingModel booking;
  const BookingWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray[25],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.shade200),
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              ProfilePicture(image: booking.provider.image, size: 40),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.provider.name,
                    style: AppTexts.tmdm.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  // Text(
                  //   "Dj Performance",
                  //   style: AppTexts.txsr.copyWith(color: AppColors.gray),
                  // ),
                ],
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.gray.shade100,
            ),
            child: Row(
              children: [
                Text(
                  booking.service.title,
                  style: AppTexts.tmdm.copyWith(color: AppColors.gray.shade700),
                ),
                Spacer(),
                GestureDetector(
                  // onTap: () => Get.to(()=> PostDetails(post)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.green.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "See Post",
                      style: AppTexts.tsms.copyWith(
                        color: AppColors.green.shade900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.gray.shade100,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 4,
                    children: [
                      CustomSvg(
                        asset: "assets/icons/calendar.svg",
                        color: AppColors.green.shade600,
                        size: 16,
                      ),
                      Text(
                        DateFormat("EEE, MMMM dd").format(booking.serviceDate),
                        style: AppTexts.tsmm.copyWith(color: AppColors.gray),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 20, color: AppColors.gray.shade300),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 4,
                    children: [
                      CustomSvg(
                        asset: "assets/icons/clock.svg",
                        color: AppColors.green.shade600,
                        size: 16,
                      ),
                      Text(
                        DateFormat("hh:mm a").format(booking.serviceDate),
                        style: AppTexts.tsmm.copyWith(color: AppColors.gray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (booking.status == "PROGRESS")
            CustomButton(text: "Mark as Complete"),
          if (booking.status == "PENDING")
            CustomButton(text: "Make Payment", isSecondary: true),
        ],
      ),
    );
  }
}
