import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/auth_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/screens/auth/reset_password.dart';
import 'package:jurnee/views/screens/home/home.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatefulWidget {
  final bool isResettingPassword;
  final String email;
  const Verification({
    super.key,
    this.isResettingPassword = false,
    required this.email,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final auth = Get.find<AuthController>();
  final otpCtrl = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool resendingOtp = false;

  void onSubmit() async {
    final message = await auth.verifyOtp(widget.email, otpCtrl.text.trim());

    if (message == "success") {
      customSnackBar("Email verification successful!", isError: false);

      if (widget.isResettingPassword) {
        Get.to(() => ResetPassword());
      } else {
        Get.offAll(() => Home(), routeName: "/app");
      }
    } else {
      customSnackBar(message);
    }
  }

  void resendOtp() async {
    setState(() {
      resendingOtp = true;
    });

    final message = await auth.resendOtp(widget.email);

    if (message == "success") {
      customSnackBar("Resent OTP successful", isError: false);
      otpCtrl.clear();
    } else {
      customSnackBar(message);
    }
    setState(() {
      resendingOtp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Text("Enter verification code", style: AppTexts.tlgb),
              const SizedBox(height: 8),
              Text(
                "A 4-digit code was sent to\n${widget.email}",
                style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 48),
              Pinput(
                focusNode: focusNode,
                controller: otpCtrl,
                defaultPinTheme: PinTheme(
                  height: 48,
                  width: 48,
                  textStyle: AppTexts.tsmr,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 1, color: Color(0xffe6e6e6)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      width: 1.5,
                      color: AppColors.green.shade600,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                cursor: Transform.translate(
                  offset: Offset(-8, 0),
                  child: Container(
                    height: 16,
                    width: 1.5,
                    color: AppColors.green.shade600,
                  ),
                ),
                onTapOutside: (event) {
                  focusNode.unfocus();
                },
              ),
              const SizedBox(height: 48),
              Text(
                "Haven’t received code yet?",
                style: AppTexts.txsr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onTap: resendOtp,
                text: "Resend Code",
                isLoading: resendingOtp,
                isSecondary: true,
                width: MediaQuery.of(context).size.width / 2,
              ),
              Spacer(),
              Obx(
                () => CustomButton(
                  onTap: onSubmit,
                  isLoading: auth.isLoading.value,
                  text: "Continue",
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
