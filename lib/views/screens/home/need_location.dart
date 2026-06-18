import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/location_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';

class NeedLocation extends StatelessWidget {
  final void Function() onTap;
  const NeedLocation({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomSvg(asset: "assets/icons/map.svg", color: AppColors.green, size: 100,),
          ),
          const SizedBox(height: 24),
          Text("Active Location", style: AppTexts.dxss),
          const SizedBox(height: 16),
          Text(
            "Allow location access to unlock all app features and get a personalized experience based on your current location.",
            style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          CustomButton(
            onTap: () async {
              await Get.find<LocationController>().getLocation();
              onTap();
            },
            text: "Allow Access",
          ),
        ],
      ),
    );
  }
}
