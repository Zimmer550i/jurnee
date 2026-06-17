import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/screens/auth/login.dart';

class NeedLogin extends StatelessWidget {
  const NeedLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomSvg(
              asset: "assets/icons/logo.svg",
              width: 72,
              height: 72,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 20),
          Text("Sign In To Continue", style: AppTexts.tlgs),
          const SizedBox(height: 8),
          Text(
            "Unlock all features by signing in to your account.",
            style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade600),
          ),
          const SizedBox(height: 24),
          CustomButton(
            onTap: () {
              Get.offAll(() => Login());
            },
            text: "Login",
          ),
        ],
      ),
    );
  }
}
