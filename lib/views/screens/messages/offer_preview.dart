import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';

class OfferPreview extends StatelessWidget {
  const OfferPreview({super.key});

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
                  Text("Plumbing Services", style: AppTexts.dxsb),
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
                          DateFormat("dd MMM, yyyy").format(DateTime.now()),
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
                          DateFormat("hh:mm aa").format(DateTime.now()),
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
                  text:
                      "Lorem ipsum dolor sit amet consectetur. Turpis montes euismod nunc odio ut imperdiet proin enim. Porttitor amet dolor nisi tempor amet dolor. Orci faucibus dui nunc diam....",
                  style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade600),
                  children: [
                    TextSpan(
                      text: "Read More",
                      style: AppTexts.tsmb.copyWith(
                        color: AppColors.green.shade700,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
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
                            "Pipe Replacement",
                            style: AppTexts.tmdb.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                          for (var i in {
                            "Quantity": "2",
                            "Unit Price": "\$100",
                            "Line Total": "\$200",
                          }.entries)
                            RichText(
                              text: TextSpan(
                                text: "${i.key}: ",
                                style: AppTexts.tsms.copyWith(
                                  color: AppColors.gray.shade700,
                                ),
                                children: [
                                  TextSpan(
                                    text: i.value,
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
                    itemCount: 2,
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
                            "\$350",
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
                            "\$50",
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
                          Text("\$350", style: AppTexts.tmdb),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Edit Offer",
                              isSecondary: true,
                            ),
                          ),
                          Expanded(child: CustomButton(text: "Send Offer")),
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
}
