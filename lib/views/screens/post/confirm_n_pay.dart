import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/booking_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class ConfirmNPay extends StatelessWidget {
  final PostModel post;
  const ConfirmNPay({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final booking = Get.find<BookingController>();
    return Scaffold(
      appBar: CustomAppBar(title: "Confirm Payment"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "Confirm & Pay",
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
                      "Order Summery",
                      style: AppTexts.tlgb.copyWith(
                        color: AppColors.green.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Service Price",
                          style: AppTexts.txls.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          post.price.toString(),
                          style: AppTexts.txls.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(color: AppColors.gray.shade200),
                    ),
                    Row(
                      children: [
                        Text(
                          "Jurnee fee",
                          style: AppTexts.txls.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "3.0",
                          style: AppTexts.txls.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(color: AppColors.gray.shade200),
                    ),
                    Row(
                      children: [
                        Text(
                          "Total",
                          style: AppTexts.txls.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$${(post.price ?? 0) + 3}",
                          style: AppTexts.txls.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Obx(
                () => CustomButton(
                  onTap: () => Get.find<BookingController>()
                      .makePayment(
                        booking.current.value!.service.id,
                        booking.current.value!.id,
                        booking.current.value!.amount + 3,
                      )
                      .then((message) {
                        if (message != "success") {
                          customSnackBar(message);
                        } else {
                          Get.until((route) => route.isFirst);
                        }
                      }),
                  isLoading: Get.find<BookingController>().isLoading.value,
                  text: "Confirm & Pay",
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "If you do not respond within 1 hour, payment will released automatically.",
                style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
