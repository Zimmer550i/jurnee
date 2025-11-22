import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/views/base/booking_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Bookings"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: index == 0
                              ? BorderSide(color: AppColors.green.shade600)
                              : BorderSide.none,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Upcoming",
                          style: AppTexts.tmds.copyWith(
                            color: index == 0
                                ? AppColors.green.shade600
                                : AppColors.gray.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: index == 1
                              ? BorderSide(color: AppColors.green.shade600)
                              : BorderSide.none,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Past",
                          style: AppTexts.tmds.copyWith(
                            color: index == 1
                                ? AppColors.green.shade600
                                : AppColors.gray.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CustomListHandler(
                horizontalPadding: 0,
                child: Column(
                  spacing: 20,
                  children: [
                    const SizedBox(height: 4),
                    for (int i = 0; i < 7; i++) BookingWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
