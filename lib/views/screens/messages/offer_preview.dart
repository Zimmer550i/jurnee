import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';

class OfferPreview extends StatefulWidget {
  const OfferPreview({super.key});

  @override
  State<OfferPreview> createState() => _OfferPreviewState();
}

class _OfferPreviewState extends State<OfferPreview> {
  final chat = Get.find<ChatController>();
  final offer = Get.find<ChatController>().lastOffer.value!;
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Offer Preview"),
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("offer.service", style: AppTexts.dxsb),
                  Text(
                    "Personal/Home Services",
                    style: AppTexts.txsr.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    spacing: 4,
                    children: [
                      CustomSvg(asset: "assets/icons/offer.svg", size: 16),
                      Expanded(
                        child: Text(
                          DateFormat("dd MMM, yyyy").format(offer.date),
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    spacing: 4,
                    children: [
                      CustomSvg(
                        asset: "assets/icons/clock.svg",
                        size: 16,
                        color: AppColors.green.shade700,
                      ),
                      Expanded(
                        child: Text(
                          "${offer.from}-${offer.to}",
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              color: Colors.white,
              child: RichText(
                text: TextSpan(
                  text: offer.description.length > 100 && !showFullDescription
                      ? "${offer.description.substring(0, 100)}..."
                      : offer.description,
                  style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade600),
                  children: [
                    if (offer.description.length > 100)
                      TextSpan(
                        text: showFullDescription ? " Show Less" : "Read More",
                        style: AppTexts.tsmb.copyWith(
                          color: AppColors.green.shade700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              showFullDescription = !showFullDescription;
                            });
                          },
                      ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    "Service Items Breakdown",
                    style: AppTexts.tlgb.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.items.elementAt(index).title,
                            style: AppTexts.tmdb.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                          for (var i in {
                            "Quantity": offer.items.elementAt(index).quantity,
                            "Unit Price":
                                "\$${offer.items.elementAt(index).unitPrice}",
                            "Line Total":
                                "\$${offer.items.elementAt(index).quantity * offer.items.elementAt(index).unitPrice}",
                          }.entries)
                            RichText(
                              text: TextSpan(
                                text: "${i.key}: ",
                                style: AppTexts.tsms.copyWith(
                                  color: AppColors.gray.shade700,
                                ),
                                children: [
                                  TextSpan(
                                    text: i.value.toString(),
                                    style: AppTexts.tsmr.copyWith(
                                      color: AppColors.gray.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    itemCount: offer.items.length,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  Column(
                    spacing: 12,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Service",
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "\$$calculateServiceCharge",
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Discount",
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "\$${offer.discount}",
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: AppColors.gray.shade200),
                      Row(
                        children: [
                          Text("Total", style: AppTexts.tmdb),
                          Spacer(),
                          Text(
                            "\$${calculateServiceCharge - offer.discount}",
                            style: AppTexts.tmdb,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: () => Get.back(),
                              text: "Edit Offer",
                              isSecondary: true,
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => CustomButton(
                                onTap: () {},
                                isLoading: chat.isLoading.value,
                                text: "Send Offer",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  num get calculateServiceCharge {
    num sum = 0;
    for (var i in offer.items) {
      sum += i.quantity * i.unitPrice;
    }
    return sum;
  }
}
