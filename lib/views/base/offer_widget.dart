import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/booking_controller.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/offer_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/screens/messages/offer_preview.dart';

class OfferWidget extends StatefulWidget {
  final OfferModel offer;
  const OfferWidget({super.key, required this.offer});

  @override
  State<OfferWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> with WidgetsBindingObserver {
  final user = Get.find<UserController>();
  final booking = Get.find<BookingController>();
  late OfferModel offer;

  bool _paymentStarted = false;

  @override
  void initState() {
    super.initState();
    offer = widget.offer;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _paymentStarted) {
      _paymentStarted = false;
      booking.getSingleBooking(offer.id).then((message) {
        if (!mounted || message != "success" || booking.current.value == null) {
          customSnackBar(message);
          return;
        }

        setState(() {
          offer = booking.current.value!;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculating the sum because my backend developer can't
    final total = offer.items.fold<num>(
      -offer.discount,
      (sum, item) => sum + (item.unitPrice * item.quantity as num),
    );

    return GestureDetector(
      onTap: () {
        Get.to(() => OfferPreview(offer: offer));
      },
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.white),
          child: Column(
            children: [
              CustomNetworkedImage(
                height: 184,
                width: double.infinity,
                url: offer.service.image,
                fit: BoxFit.cover,
                radius: 0,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.service.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTexts.tlgs.copyWith(
                          color: AppColors.gray.shade600,
                        ),
                      ),

                      Row(
                        spacing: 4,
                        children: [
                          CustomSvg(asset: "assets/icons/location.svg"),
                          Text(
                            Get.find<PostController>().getDistance(
                              offer.service.location!.coordinates[0],
                              offer.service.location!.coordinates[1],
                            ),
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                          Container(),
                          // CustomSvg(asset: "assets/icons/star.svg"),
                          // Text(
                          //   "4.5",
                          //   style: AppTexts.tsmm.copyWith(
                          //     color: AppColors.gray.shade600,
                          //   ),
                          // ),
                        ],
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          CustomSvg(asset: "assets/icons/offer.svg", size: 16),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  DateFormat("dd MMM, yyyy").format(offer.date),
                                  style: AppTexts.tsmr.copyWith(
                                    color: AppColors.gray.shade600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "${Formatter.timeFormatter(
                                    time: TimeOfDay(hour: int.parse(offer.from.split(":").first), minute: int.parse(offer.from.split(":").last)),
                                  )}-${Formatter.timeFormatter(
                                    time: TimeOfDay(hour: int.parse(offer.to.split(":").first), minute: int.parse(offer.to.split(":").last)),
                                  )}",
                                  style: AppTexts.tsmr.copyWith(
                                    color: AppColors.gray.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Text(
                        offer.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.gray.shade600,
                        ),
                      ),

                      Text(
                        "Total: \$${Formatter.numberFormatter(total)}",
                        style: AppTexts.tlgb,
                      ),
                      // if (Get.find<UserController>().userData!.id ==
                      //     offer.customer)
                      if (offer.status != "accepted")
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: CustomButton(
                                onTap: () =>
                                    Get.to(() => OfferPreview(offer: offer)),
                                text: "View Offer",
                                isSecondary: true,
                                height: 44,
                              ),
                            ),
                            if (offer.provider.id !=
                                Get.find<UserController>().userData!.id)
                              Expanded(
                                child: Obx(
                                  () => CustomButton(
                                    onTap: () {
                                      _paymentStarted = true;

                                      booking
                                          .makePayment(
                                            offer.id,
                                            total.toDouble(),
                                          )
                                          .then((message) {
                                            if (message != "success") {
                                              _paymentStarted = false;
                                              customSnackBar(message);
                                            }
                                          });
                                    },
                                    isLoading: booking.isLoading.value,
                                    text: "Accept",
                                    height: 44,
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
