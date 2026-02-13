import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/models/booking_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class MarkAsComplete extends StatelessWidget {
  final BookingModel booking;
  const MarkAsComplete({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Mark As Compelte"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "Mark as Complete",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: AppColors.green.shade700,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisSize: MainAxisSize.min,
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
                      DateFormat().format(booking.serviceDate),
                      style: AppTexts.tmdr,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "at ${DateFormat("hh:mm a").format(booking.serviceDate)}",
                      style: AppTexts.tmdr,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/location.svg", size: 24),
                        Expanded(
                          child: Text(
                            booking.provider.address,
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.gray.shade200, height: 32),
                    Row(
                      children: [
                        Expanded(child: Text("Quoted", style: AppTexts.tmdr)),
                        Text("\$${booking.amount}", style: AppTexts.tmdr),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              CustomButton(text: "Mark as Complete"),
              const SizedBox(height: 16),
              Text(
                "Payment will be released once the customer confirms.",
                style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
