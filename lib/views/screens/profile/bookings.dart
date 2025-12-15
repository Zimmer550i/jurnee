import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/booking_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/booking_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_loading.dart';

class Bookings extends StatefulWidget {
  final bool showClientBooking;
  const Bookings({super.key, this.showClientBooking = false});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  final booking = Get.find<BookingController>();
  int index = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData({bool loadMode = false}) async {
    late String message;
    if (widget.showClientBooking) {
      if (index == 0) {
        message = await booking.fetchBookings(
          "incompleted",
          loadMore: loadMode,
        );
      } else {
        message = await booking.fetchBookings("completed", loadMore: loadMode);
      }
    } else {
      if (index == 0) {
        message = await booking.fetchBookings("upcoming", loadMore: loadMode);
      } else {
        message = await booking.fetchBookings("past", loadMore: loadMode);
      }
    }

    if (message != "success") {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.showClientBooking ? "Client Bookings" : "My Bookings",
      ),
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
                        fetchData();
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
                          widget.showClientBooking ? "Incomplete" : "Ongoing",
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
                        fetchData();
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
                          widget.showClientBooking ? "Completed" : "Past",
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
              child: Obx(
                () => CustomListHandler(
                  horizontalPadding: 0,
                  isLoading: booking.isFirstLoad.value,
                  onLoadMore: () => fetchData(loadMode: true),
                  onRefresh: () => fetchData(),
                  child: Column(
                    spacing: 20,
                    children: [
                      const SizedBox(height: 4),
                      for (var i in booking.bookings) BookingWidget(booking: i),
                      if (booking.isMoreLoading.value) CustomLoading(),
                      if (!booking.isMoreLoading.value)
                        Text(
                          "End of list",
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.gray.shade300,
                          ),
                        ),
                    ],
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
