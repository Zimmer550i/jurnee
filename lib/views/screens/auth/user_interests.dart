import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';

class UserInterests extends StatefulWidget {
  const UserInterests({super.key});

  @override
  State<UserInterests> createState() => _UserInterestsState();
}

class _UserInterestsState extends State<UserInterests> {
  final user = Get.find<UserController>();
  bool event = false;
  bool deal = false;
  bool service = false;
  bool alerts = false;

  void onSubmit() async {
    List<String> interests = [];
    if (event) {
      interests.add("events");
    }
    if (deal) {
      interests.add("deals");
    }
    if (service) {
      interests.add("services");
    }
    if (alerts) {
      interests.add("alerts");
    }
    final message = await user.updateUserData({"interested": interests});

    if (message == "success") {
      Get.back();
      customSnackBar("Thank you for letting us know", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                "Choose Your Interests",
                textAlign: TextAlign.center,
                style: AppTexts.dxsb,
              ),
              const SizedBox(height: 8),
              Text(
                "Select categories that align with your goals and passions to personalize your experience.",
                textAlign: TextAlign.center,
                style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 40),
              Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  options(
                    "Events",
                    "Discover exciting local gatherings, festivals, and parties.",
                    "event",
                    event,
                    () {
                      setState(() {
                        event = !event;
                      });
                    },
                  ),
                  options(
                    "Deals",
                    "Find the local discounts and special offers around you",
                    "deal",
                    deal,
                    () {
                      setState(() {
                        deal = !deal;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  options(
                    "Services",
                    "Explore local services and providers available in your area",
                    "service",
                    service,
                    () {
                      setState(() {
                        service = !service;
                      });
                    },
                  ),
                  options(
                    "Alerts",
                    "Stay informed about missing persons, safety updates, and community notices.",
                    "alerts",
                    alerts,
                    () {
                      setState(() {
                        alerts = !alerts;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Obx(
                () => CustomButton(
                  onTap: onSubmit,
                  text: "Continue",
                  isLoading: user.isLoading.value,
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                onTap: () {
                  Get.back();
                },
                text: "Skip for now",
                isSecondary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget options(
    String title,
    String subtitle,
    String assetName,
    bool isSelected,
    Function() onChanged,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onChanged,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.green.shade600
                  : AppColors.gray.shade300,
            ),
          ),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSvg(asset: "assets/icons/$assetName.svg", size: 40),
                  Checkbox(
                    value: isSelected,
                    onChanged: (val) {},
                    activeColor: AppColors.green.shade600,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      color: AppColors.gray.shade200,
                      width: 1.5,
                    ),
                  ),
                ],
              ),
              Text(
                title,
                style: AppTexts.txlb.copyWith(color: AppColors.gray.shade700),
              ),
              SizedBox(
                height: 100,
                child: Text(
                  subtitle,
                  style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
