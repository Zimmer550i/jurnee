import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/booking_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/models/schedule_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/post/confirm_n_pay.dart';

class BookingConfirmation extends StatelessWidget {
  final PostModel post;
  final Schedule schedule;
  final TimeSlot timeSlot;
  final DateTime date;
  const BookingConfirmation({
    super.key,
    required this.post,
    required this.schedule,
    required this.timeSlot,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Booking Confirmation"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text(
                "Confirm Booking",
                style: AppTexts.dsms.copyWith(color: AppColors.green.shade600),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfilePicture(image: post.author.image, size: 52),
                  const SizedBox(width: 8),
                  Text(
                    post.author.name,
                    style: AppTexts.txlm.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gray.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("EEEE, MMMM d, yyyy").format(date),
                      style: AppTexts.txls.copyWith(
                        color: AppColors.gray.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "at ${DateFormat("hh:mm a").format(date)}",
                      style: AppTexts.txls.copyWith(
                        color: AppColors.gray.shade700,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(color: AppColors.gray.shade200),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvg(asset: "assets/icons/location.svg", size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            post.address,
                            style: AppTexts.txls.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                title: "Message (Optional)",
                hintText: "Enter your message",
              ),
              Spacer(),
              Obx(
                () => CustomButton(
                  onTap: () => Get.find<BookingController>()
                      .confirmBooking(
                        serviceId: post.id,
                        scheduleId: schedule.id!,
                        slotId: timeSlot.id!,
                        serviceDate: date,
                        slotStart: timeSlot.start!,
                        slotEnd: timeSlot.end!,
                        amount: post.price!,
                      )
                      .then((message) {
                        if (message == "success") {
                          Get.to(() => ConfirmNPay(post: post));
                        } else {
                          customSnackBar(message);
                        }
                      }),
                  isLoading: Get.find<BookingController>().isLoading.value,
                  text: "Confirm Booking",
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(text: "Cancel Booking", isSecondary: true),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
